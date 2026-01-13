#!/bin/bash
# Best Practices Compliance Checker
# Used by /4_review to validate code against best practices
# Usage: ./check_compliance.sh [BEST_PRACTICES_DIR] [FILES_TO_CHECK...]

set -e

BEST_PRACTICES_DIR="${1:-.claude/best-practices}"
shift || true

echo "╔════════════════════════════════════════╗"
echo "║  Best Practices Compliance Check       ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Check if best practices directory exists
if [ ! -d "$BEST_PRACTICES_DIR" ]; then
    echo "⚠️  No best practices found at: $BEST_PRACTICES_DIR"
    echo ""
    echo "To generate best practices, run:"
    echo "  /best-practices"
    echo ""
    echo "Or use the code-standards skill:"
    echo "  bash skills/code-standards/scripts/extract_pr_comments.sh REPO"
    echo ""
    exit 0
fi

# Count best practices files
BP_COUNT=$(find "$BEST_PRACTICES_DIR" -name "*.md" -type f | wc -l | tr -d ' ')

if [ "$BP_COUNT" -eq 0 ]; then
    echo "⚠️  Best practices directory is empty"
    exit 0
fi

echo "📚 Found $BP_COUNT best practices documents"
echo ""

# List available best practices
echo "Available Best Practices Categories:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
find "$BEST_PRACTICES_DIR" -name "*.md" -type f | while read -r file; do
    basename=$(basename "$file" .md)
    echo "  • $basename"
done
echo ""

# If no files specified, show summary and exit
if [ $# -eq 0 ]; then
    echo "💡 Usage:"
    echo "   $0 $BEST_PRACTICES_DIR file1.ts file2.ts ..."
    echo ""
    echo "   Or let Claude Code's /4_review automatically check files"
    exit 0
fi

echo "🔍 Files to check: $#"
echo ""

# For each file, determine relevant best practices based on file type
for file in "$@"; do
    if [ ! -f "$file" ]; then
        continue
    fi

    echo "Checking: $file"

    # Determine file type and relevant best practices
    case "$file" in
        *.ts|*.tsx|*.js|*.jsx)
            echo "  → Relevant: naming-conventions, error-handling, type-safety"
            ;;
        *.test.ts|*.spec.ts)
            echo "  → Relevant: testing, naming-conventions"
            ;;
        *.md)
            echo "  → Relevant: documentation"
            ;;
        *)
            echo "  → Relevant: code-organization, naming-conventions"
            ;;
    esac
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Analysis complete"
echo ""
echo "📝 Next: Claude Code will review files against these practices"
