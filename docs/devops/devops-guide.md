# DevOps Deployment Guide

> **⚠️ MANDATORY READ**: This document MUST be read and validated before ANY deployment operations.

---

## Project Information

- **Project Name**: [Project Name]
- **Environment**: [Development / Staging / Production]
- **Last Updated**: [YYYY-MM-DD]
- **Maintained By**: [Team/Person Name]

---

## Pre-Deployment Checklist

### Infrastructure Requirements

- [ ] Cloud Platform: [AWS / GCP / Azure / Other]
- [ ] Region/Zone: [Specify]
- [ ] VPC/Network Configuration: [Specify]
- [ ] Security Groups/Firewall Rules: [Specify]

### Application Requirements

- [ ] Runtime Environment: [Node.js / Python / Java / Other]
- [ ] Runtime Version: [Specify]
- [ ] Environment Variables: [List or reference secrets management]
- [ ] Configuration Files: [List required files]

### Database Requirements

- [ ] Database Type: [PostgreSQL / MySQL / MongoDB / Other]
- [ ] Database Version: [Specify]
- [ ] Migration Scripts: [Location and execution order]
- [ ] Backup Strategy: [Describe]

### Dependencies & Services

- [ ] External APIs: [List with endpoints]
- [ ] Third-party Services: [List]
- [ ] Message Queues: [Redis / RabbitMQ / Kafka / None]
- [ ] Caching Layer: [Redis / Memcached / None]

---

## Deployment Configuration

### Container Configuration

```yaml
# Docker Image
Image: [registry/image:tag]
Ports: [list ports]
Volumes: [list volumes]
Environment: [reference env vars]
```

### Kubernetes Configuration (if applicable)

```yaml
# K8s Resources
Namespace: [namespace]
Replicas: [number]
Resource Limits:
  CPU: [limit]
  Memory: [limit]
Service Type: [ClusterIP / NodePort / LoadBalancer]
Ingress: [domain/path]
```

### CI/CD Pipeline

- **Pipeline Tool**: [GitHub Actions / GitLab CI / Jenkins / Other]
- **Deployment Strategy**: [Rolling / Blue-Green / Canary]
- **Rollback Plan**: [Describe rollback procedure]

---

## Deployment Steps

### 1. Pre-Deployment Validation

```bash
# Add specific validation commands
# Example:
# - Check database connectivity
# - Verify environment variables
# - Test external API connectivity
```

### 2. Deployment Execution

```bash
# Add specific deployment commands
# Example:
# - Build Docker image
# - Push to registry
# - Deploy to K8s/ECS/EC2
```

### 3. Post-Deployment Validation

```bash
# Add validation commands
# Example:
# - Health check endpoint
# - Smoke tests
# - Log verification
```

---

## Monitoring & Alerting

### Health Checks

- **Liveness Probe**: [Endpoint and expected response]
- **Readiness Probe**: [Endpoint and expected response]
- **Startup Probe**: [If applicable]

### Logging

- **Log Aggregation**: [ELK / CloudWatch / Datadog / Other]
- **Log Levels**: [INFO / WARN / ERROR]
- **Log Retention**: [Duration]

### Metrics & Monitoring

- **Monitoring Tool**: [Prometheus / Grafana / CloudWatch / Datadog]
- **Key Metrics**: [CPU, Memory, Request Rate, Error Rate, etc.]
- **Dashboards**: [Links to dashboards]

### Alerting

- **Alert Channels**: [Slack / Email / PagerDuty]
- **Critical Alerts**: [List conditions]
- **Warning Alerts**: [List conditions]

---

## Security Configuration

### Secrets Management

- **Secrets Store**: [AWS Secrets Manager / Vault / K8s Secrets]
- **Rotation Policy**: [Describe]
- **Access Control**: [IAM roles / RBAC]

### SSL/TLS Configuration

- **Certificate Provider**: [Let's Encrypt / ACM / Other]
- **Certificate Renewal**: [Automatic / Manual]

### Network Security

- **Firewall Rules**: [Specify allowed IPs/ranges]
- **WAF Configuration**: [If applicable]
- **DDoS Protection**: [CloudFlare / AWS Shield / Other]

---

## Backup & Disaster Recovery

### Backup Strategy

- **Database Backups**: [Frequency, retention period]
- **Application State**: [If applicable]
- **Configuration Backups**: [Location]

### Disaster Recovery Plan

- **RTO (Recovery Time Objective)**: [Time]
- **RPO (Recovery Point Objective)**: [Time]
- **Recovery Procedures**: [Describe steps]

---

## Scaling Configuration

### Horizontal Scaling

- **Min Replicas**: [number]
- **Max Replicas**: [number]
- **Scaling Triggers**: [CPU / Memory / Custom Metrics]

### Vertical Scaling

- **Instance Types**: [Specify]
- **Scaling Limits**: [CPU, Memory]

---

## Troubleshooting Guide

### Common Issues

1. **Issue**: [Describe common issue]
   - **Symptoms**: [What to look for]
   - **Solution**: [How to resolve]

2. **Issue**: [Describe another issue]
   - **Symptoms**: [What to look for]
   - **Solution**: [How to resolve]

### Emergency Contacts

- **On-Call Engineer**: [Name/Contact]
- **Team Lead**: [Name/Contact]
- **Escalation Path**: [Describe]

---

## References

- **Architecture Diagram**: [Link or location]
- **API Documentation**: [Link]
- **Runbook**: [Link if separate]
- **Post-Mortem Templates**: [Link]

---

## Change Log

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| YYYY-MM-DD | 1.0.0 | Initial version | [Name] |

---

## Approval

- [ ] **DevOps Engineer**: [Name] - [Date]
- [ ] **CTO Review**: [Name] - [Date]
- [ ] **System Architect Review**: [Name] - [Date]

---

**⚠️ WARNING**: Deployment without completing this guide may result in:
- Service downtime
- Data loss
- Security vulnerabilities
- Non-compliance with standards

**DO NOT proceed with deployment if this guide is incomplete or not approved.**
