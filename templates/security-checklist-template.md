# Security Checklist Template

## Overview
**Application**: [Application Name]
**Version**: [Version Number]
**Assessment Date**: [Date]
**Assessed By**: [Security Reviewer Name]
**Risk Level**: [Low | Medium | High | Critical]

## Executive Summary
**Overall Security Score**: [X/10]
**Critical Issues Found**: [Number]
**High Priority Issues**: [Number]
**Recommendation**: [Deploy | Deploy with Conditions | Do Not Deploy]

## Authentication & Authorization

### Authentication Security
- [ ] **Strong Password Policy**
  - Minimum 8 characters with complexity requirements
  - Password strength meter implemented
  - Password history prevents reuse of last 5 passwords
  
- [ ] **Multi-Factor Authentication (MFA)**
  - MFA available for admin accounts
  - MFA enforced for sensitive operations
  - Backup authentication methods provided

- [ ] **Session Management**
  - Secure session token generation (cryptographically secure)
  - Session timeout implemented (max 30 minutes inactivity)
  - Session invalidation on logout
  - Concurrent session limits enforced

- [ ] **Login Security**
  - Account lockout after failed attempts (max 5 attempts)
  - CAPTCHA after multiple failed attempts
  - Login attempt logging and monitoring
  - No username enumeration vulnerabilities

### Authorization Security
- [ ] **Access Control**
  - Role-based access control (RBAC) implemented
  - Principle of least privilege enforced
  - Authorization checks on all protected resources
  - No direct object references without authorization

- [ ] **Permission Management**
  - Permissions properly scoped and granular
  - Default deny policy implemented
  - Administrative functions properly protected
  - No privilege escalation vulnerabilities

## Input Validation & Data Security

### Input Validation
- [ ] **Server-Side Validation**
  - All user input validated on server-side
  - Input length limits enforced
  - Data type validation implemented
  - Business logic validation applied

- [ ] **Injection Prevention**
  - SQL injection prevention (parameterized queries)
  - NoSQL injection prevention
  - Command injection prevention
  - LDAP injection prevention
  - XPath injection prevention

- [ ] **Cross-Site Scripting (XSS) Prevention**
  - Output encoding/escaping implemented
  - Content Security Policy (CSP) configured
  - Input sanitization for rich text
  - DOM-based XSS prevention

### Data Protection
- [ ] **Data Encryption**
  - Sensitive data encrypted at rest (AES-256)
  - Data encrypted in transit (TLS 1.2+)
  - Database encryption enabled
  - Backup encryption implemented

- [ ] **Sensitive Data Handling**
  - PII data identified and protected
  - Payment data compliance (PCI DSS if applicable)
  - Sensitive data not logged
  - Data masking in non-production environments

## Network & Communication Security

### HTTPS/TLS Configuration
- [ ] **SSL/TLS Implementation**
  - TLS 1.2 or higher enforced
  - Strong cipher suites configured
  - Certificate properly configured and valid
  - HSTS (HTTP Strict Transport Security) enabled

- [ ] **Certificate Management**
  - Valid SSL certificate from trusted CA
  - Certificate expiration monitoring
  - Certificate chain properly configured
  - No mixed content warnings

### API Security
- [ ] **API Authentication**
  - API authentication required (OAuth 2.0/JWT)
  - API key management implemented
  - Rate limiting configured
  - API versioning strategy implemented

- [ ] **API Authorization**
  - Proper scope-based authorization
  - Resource-level permissions
  - Cross-origin resource sharing (CORS) configured
  - No sensitive data in URL parameters

## Infrastructure Security

### Server Security
- [ ] **Server Hardening**
  - Operating system updates applied
  - Unnecessary services disabled
  - Security patches current
  - Default accounts removed/secured

- [ ] **Web Server Configuration**
  - Security headers configured
  - Directory browsing disabled
  - Error pages don't reveal sensitive information
  - File upload restrictions implemented

### Database Security
- [ ] **Database Hardening**
  - Database access restricted to application only
  - Strong database credentials
  - Database logging enabled
  - Regular database backups with encryption

- [ ] **Database Access Control**
  - Principle of least privilege for database accounts
  - No shared database accounts
  - Database connection encryption
  - SQL injection prevention measures

## Application Security

### Error Handling & Logging
- [ ] **Error Management**
  - Generic error messages to users
  - Detailed errors logged securely
  - No stack traces exposed to users
  - Error handling doesn't reveal system information

- [ ] **Security Logging**
  - Authentication attempts logged
  - Authorization failures logged
  - Administrative actions logged
  - Security events monitored and alerted

### File Upload Security
- [ ] **Upload Restrictions**
  - File type restrictions enforced
  - File size limits implemented
  - Virus scanning for uploads
  - Files stored outside web root

- [ ] **Upload Validation**
  - File content validation (not just extension)
  - Image processing security (if applicable)
  - No execution of uploaded files
  - Upload rate limiting

## Security Headers & Configuration

### HTTP Security Headers
- [ ] **Content Security Policy (CSP)**
  ```
  Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline'
  ```

- [ ] **Strict Transport Security (HSTS)**
  ```
  Strict-Transport-Security: max-age=31536000; includeSubDomains
  ```

- [ ] **X-Frame-Options**
  ```
  X-Frame-Options: DENY
  ```

- [ ] **X-Content-Type-Options**
  ```
  X-Content-Type-Options: nosniff
  ```

- [ ] **X-XSS-Protection**
  ```
  X-XSS-Protection: 1; mode=block
  ```

- [ ] **Referrer Policy**
  ```
  Referrer-Policy: strict-origin-when-cross-origin
  ```

### Cookie Security
- [ ] **Secure Cookie Configuration**
  - HttpOnly flag set on session cookies
  - Secure flag set for HTTPS cookies
  - SameSite attribute configured
  - Appropriate cookie expiration

## Privacy & Compliance

### Data Privacy
- [ ] **Privacy Controls**
  - Privacy policy implemented and accessible
  - Cookie consent mechanism (if required)
  - Data subject rights supported (GDPR/CCPA)
  - Data retention policies implemented

- [ ] **Data Minimization**
  - Only necessary data collected
  - Data purpose clearly defined
  - Unnecessary data regularly purged
  - Data sharing agreements in place

### Compliance Requirements
- [ ] **Regulatory Compliance**
  - GDPR compliance (if applicable)
  - CCPA compliance (if applicable)
  - PCI DSS compliance (if handling payments)
  - HIPAA compliance (if handling health data)
  - SOX compliance (if financial data)

## Vulnerability Assessment

### OWASP Top 10 (2021)
- [ ] **A01:2021 - Broken Access Control**
  - Access control checks implemented and tested
  - No insecure direct object references
  - CORS properly configured

- [ ] **A02:2021 - Cryptographic Failures**
  - Strong encryption algorithms used
  - Proper key management implemented
  - No hardcoded secrets in code

- [ ] **A03:2021 - Injection**
  - SQL injection prevention verified
  - Command injection prevention verified
  - NoSQL injection prevention verified

- [ ] **A04:2021 - Insecure Design**
  - Threat modeling conducted
  - Secure design patterns implemented
  - Business logic flaws addressed

- [ ] **A05:2021 - Security Misconfiguration**
  - Default configurations changed
  - Error handling properly configured
  - Security features enabled

- [ ] **A06:2021 - Vulnerable and Outdated Components**
  - Dependency scanning implemented
  - Regular updates scheduled
  - No known vulnerable components

- [ ] **A07:2021 - Identification and Authentication Failures**
  - Strong authentication mechanisms
  - Session management secure
  - No authentication bypass

- [ ] **A08:2021 - Software and Data Integrity Failures**
  - Code integrity verification
  - Secure CI/CD pipeline
  - Supply chain security

- [ ] **A09:2021 - Security Logging and Monitoring Failures**
  - Comprehensive logging implemented
  - Real-time monitoring configured
  - Incident response procedures

- [ ] **A10:2021 - Server-Side Request Forgery (SSRF)**
  - URL validation implemented
  - Network segmentation configured
  - No internal service exposure

## Security Testing Results

### Automated Security Testing
- [ ] **Static Analysis Security Testing (SAST)**
  - Tool used: [Tool Name]
  - Critical issues: [Number]
  - High issues: [Number]
  - Status: [Pass/Fail]

- [ ] **Dynamic Analysis Security Testing (DAST)**
  - Tool used: [Tool Name]
  - Critical issues: [Number]
  - High issues: [Number]
  - Status: [Pass/Fail]

- [ ] **Dependency Scanning**
  - Tool used: [Tool Name]
  - Vulnerable dependencies: [Number]
  - Critical vulnerabilities: [Number]
  - Status: [Pass/Fail]

### Manual Security Testing
- [ ] **Penetration Testing**
  - Authentication bypass attempts
  - Authorization testing
  - Input validation testing
  - Session management testing

- [ ] **Business Logic Testing**
  - Workflow bypass attempts
  - Race condition testing
  - Business rule violation testing
  - Privilege escalation testing

## Critical Security Findings

### Critical Issues (Fix before deployment)
| Issue | Location | Risk | Impact | Remediation |
|-------|----------|------|--------|-------------|
| SQL Injection | login.php:42 | Critical | Data breach | Use parameterized queries |
| Stored XSS | comment.js:18 | High | Account takeover | Implement output encoding |

### High Priority Issues
| Issue | Location | Risk | Impact | Remediation |
|-------|----------|------|--------|-------------|
| Weak password policy | auth.js:67 | Medium | Account compromise | Enforce strong passwords |
| Missing CSRF protection | forms.php:23 | Medium | Unauthorized actions | Implement CSRF tokens |

## Recommendations

### Immediate Actions (Critical - Fix Now)
1. **Fix SQL injection vulnerability** in user authentication
2. **Implement output encoding** to prevent XSS attacks
3. **Configure security headers** to prevent common attacks
4. **Enable HTTPS** for all communications

### Short-term Actions (1-4 weeks)
1. **Implement comprehensive input validation**
2. **Add rate limiting** to prevent abuse
3. **Configure security monitoring** and alerting
4. **Conduct security code review** of all user inputs

### Long-term Actions (1-3 months)
1. **Implement security training** for development team
2. **Establish security testing** in CI/CD pipeline
3. **Conduct regular penetration testing**
4. **Develop incident response procedures**

## Security Approval

### Review Status
- [ ] **Critical issues resolved**
- [ ] **High priority issues addressed**
- [ ] **Security testing completed**
- [ ] **Documentation updated**
- [ ] **Team training completed**

### Final Assessment
**Security Clearance**: [Approved | Conditional Approval | Rejected]

**Conditions** (if any):
1. [Condition that must be met before deployment]
2. [Additional security requirements]

**Risk Acceptance**: 
- **Accepted Risks**: [List any risks accepted by business]
- **Risk Owner**: [Person accepting the risk]
- **Review Date**: [When risk should be re-evaluated]

---

**Security Review Completed**: [Date]
**Next Security Review**: [Date]
**Security Officer Approval**: [Name and Signature]
**Risk Acceptance**: [Business Owner Signature]
