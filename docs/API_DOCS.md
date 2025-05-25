# 📡 PABLOS API Documentation

## Overview

PABLOS integrates with a sophisticated AI agent platform to provide intelligent conversational capabilities. This document outlines the API endpoints, request/response formats, and integration patterns.

## Base Configuration

```
Base URL: https://wnkqkhbxixel3rjeb66derpx.agents.do-ai.run
Agent ID: 6c58e25c-3913-11f0-bf8f-4e013e2ddde4
Chatbot ID: SKmeFU5N3XgR9bdQ16Nwl86jsj2df73Q
```

## Authentication

All requests must include the following headers:

```http
Content-Type: application/json
Accept: application/json
X-Agent-ID: 6c58e25c-3913-11f0-bf8f-4e013e2ddde4
X-Chatbot-ID: SKmeFU5N3XgR9bdQ16Nwl86jsj2df73Q
X-Client-Version: 1.0.0
User-Agent: PABLOS-Mobile/1.0.0
```

## Core Endpoints

### 💬 Chat API

#### Send Message
Send a message to PABLOS and receive an AI response.

```http
POST /api/chat
```

**Request Body:**
```json
{
  "message": "Bantuin gw setup Digital Ocean droplet dong",
  "agent_id": "6c58e25c-3913-11f0-bf8f-4e013e2ddde4",
  "chatbot_id": "SKmeFU5N3XgR9bdQ16Nwl86jsj2df73Q",
  "timestamp": "2024-12-01T10:30:00Z",
  "conversation_id": "conv_123456789",
  "context": {
    "user_id": "user_abc123",
    "session_id": "session_xyz789",
    "previous_messages": [
      "Hi PABLOS!",
      "Halo bestie! Gw Pablos, literally siap bantuin elu anything!"
    ]
  }
}
```

**Response:**
```json
{
  "id": "response_987654321",
  "text": "Oh technical question nih! Gw expert banget di Digital Ocean sama server management. Literally, bos gw Tama udah train gw buat handle semua VPS issues. Spill the details dong - what specific droplet setup elu butuh?",
  "type": "text",
  "status": "success",
  "confidence": "high",
  "category": "technical",
  "timestamp": "2024-12-01T10:30:02Z",
  "processing_time_ms": 1250,
  "suggestions": [
    "Setup Ubuntu droplet",
    "Configure Nginx web server",
    "Setup database connection"
  ],
  "actions": [
    {
      "id": "action_setup_guide",
      "type": "link",
      "label": "Digital Ocean Setup Guide",
      "description": "Comprehensive droplet setup tutorial"
    }
  ],
  "context": {
    "conversation_id": "conv_123456789",
    "message_index": 2
  },
  "analytics": {
    "token_count": 45,
    "sentiment_score": 0.8,
    "detected_topics": ["digital_ocean", "server_setup", "technical_help"],
    "complexity_score": 0.6,
    "relevance_score": 0.9
  }
}
```

### 🔍 System Status

#### Health Check
Check if the AI service is operational.

```http
GET /api/health
```

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2024-12-01T10:30:00Z",
  "services": {
    "ai_engine": "operational",
    "database": "operational",
    "cache": "operational"
  },
  "response_time_ms": 45
}
```

#### System Status
Get detailed system status and metrics.

```http
GET /api/status
```

**Response:**
```json
{
  "system": {
    "status": "operational",
    "version": "2.1.0",
    "uptime_hours": 168,
    "last_restart": "2024-11-24T08:00:00Z"
  },
  "performance": {
    "avg_response_time_ms": 850,
    "requests_per_minute": 45,
    "success_rate": 99.7,
    "error_rate": 0.3
  },
  "ai_metrics": {
    "model_version": "PABLOS-v2.1",
    "confidence_avg": 0.87,
    "processing_capacity": "normal"
  }
}
```

### ⚙️ Configuration

#### Get Configuration
Retrieve system configuration and capabilities.

```http
GET /api/config
```

**Response:**
```json
{
  "agent": {
    "id": "6c58e25c-3913-11f0-bf8f-4e013e2ddde4",
    "name": "PABLOS",
    "version": "1.0.0",
    "capabilities": [
      "digital_ocean_expertise",
      "cybersecurity_advice",
      "web_development_help",
      "academic_support",
      "general_conversation"
    ]
  },
  "personality": {
    "language_style": "bahasa_jaksel",
    "tone": "friendly_professional",
    "creator_reference": "bos gw Tama"
  },
  "limits": {
    "max_message_length": 5000,
    "rate_limit_per_minute": 60,
    "conversation_timeout_minutes": 30
  }
}
```

### 📊 Analytics & Metrics

#### Get Metrics
Retrieve usage metrics and analytics.

```http
GET /api/metrics
```

**Response:**
```json
{
  "usage": {
    "total_conversations": 15420,
    "total_messages": 67890,
    "active_users_today": 234,
    "avg_session_duration_minutes": 12.5
  },
  "categories": {
    "technical": 35.2,
    "general": 28.7,
    "security": 18.9,
    "academic": 12.1,
    "personal": 5.1
  },
  "satisfaction": {
    "avg_rating": 4.7,
    "positive_feedback": 94.3,
    "response_helpfulness": 89.6
  }
}
```

### 📝 Feedback

#### Send Feedback
Submit user feedback about AI responses.

```http
POST /api/feedback
```

**Request Body:**
```json
{
  "feedback": "Response was very helpful for Digital Ocean setup!",
  "type": "positive",
  "rating": 5,
  "response_id": "response_987654321",
  "timestamp": "2024-12-01T10:35:00Z",
  "metadata": {
    "category": "technical",
    "helpful": true,
    "suggestions": "Maybe add more specific commands"
  }
}
```

**Response:**
```json
{
  "status": "received",
  "feedback_id": "feedback_abc123",
  "message": "Thank you for your feedback!"
}
```

## Error Handling

### Standard Error Response
```json
{
  "error": {
    "code": "INVALID_REQUEST",
    "message": "Message content is required",
    "details": "The 'message' field cannot be empty",
    "timestamp": "2024-12-01T10:30:00Z",
    "request_id": "req_xyz789"
  }
}
```

### Common Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `INVALID_REQUEST` | 400 | Malformed request body |
| `UNAUTHORIZED` | 401 | Invalid or missing credentials |
| `FORBIDDEN` | 403 | Access denied |
| `NOT_FOUND` | 404 | Endpoint not found |
| `RATE_LIMITED` | 429 | Too many requests |
| `AI_SERVICE_ERROR` | 500 | AI processing failed |
| `SERVICE_UNAVAILABLE` | 503 | System maintenance |

## Rate Limiting

- **Chat API**: 60 requests per minute
- **Status API**: 10 requests per minute  
- **Other APIs**: 30 requests per minute

Rate limit headers are included in responses:
```http
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1638360000
```

## Request/Response Examples

### Example 1: General Greeting
```http
POST /api/chat
{
  "message": "Hi PABLOS!"
}
```

Response:
```json
{
  "text": "Halo bestie! Gw Pablos, literally siap bantuin elu anything! From droplet setup sampe curhat session - what's up?",
  "category": "greeting",
  "confidence": "high"
}
```

### Example 2: Technical Question
```http
POST /api/chat
{
  "message": "How do I secure my VPS against attacks?"
}
```

Response:
```json
{
  "text": "Wah cybersecurity question! Gw literally expert di area ini, bestie. Bos gw Tama always emphasize pentingnya security yang proper. Here's what you need to do...",
  "category": "security",
  "suggestions": [
    "Configure firewall rules",
    "Update system packages",
    "Setup fail2ban"
  ]
}
```

### Example 3: Academic Help
```http
POST /api/chat
{
  "message": "Bantuin gw dengan research methodology dong"
}
```

Response:
```json
{
  "text": "Academic support adalah salah satu expertise gw! Bos gw Tama make sure gw always updated dengan latest research methodologies. What specific aspect of research methodology elu butuh help with?",
  "category": "academic",
  "actions": [
    {
      "type": "guide",
      "label": "Research Methodology Guide"
    }
  ]
}
```

## WebSocket API (Future)

Real-time chat functionality will be available via WebSocket:

```
WSS: wss://wnkqkhbxixel3rjeb66derpx.agents.do-ai.run/ws
```

## SDK Integration

### Flutter Integration
```dart
final service = PablosAIService();
final response = await service.sendMessage("Hi PABLOS!");
```

### JavaScript Integration
```javascript
const response = await fetch('/api/chat', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'X-Agent-ID': '6c58e25c-3913-11f0-bf8f-4e013e2ddde4'
  },
  body: JSON.stringify({ message: 'Hi PABLOS!' })
});
```

## Best Practices

### 1. Message Formatting
- Keep messages under 5000 characters
- Use clear, specific language
- Include context when relevant

### 2. Error Handling
- Always handle network errors gracefully
- Implement retry logic for transient failures
- Show user-friendly error messages

### 3. Performance
- Cache configuration responses
- Implement proper timeout handling
- Use connection pooling for multiple requests

### 4. Security
- Never expose API keys in client code
- Validate all user inputs
- Implement proper authentication

## Monitoring & Debugging

### Request Logging
Enable request logging in development:
```dart
AppConfig.features['enable_request_logging'] = true;
```

### Debug Headers
Add debug information to requests:
```http
X-Debug-Mode: true
X-Request-ID: unique-request-id
```

## Changelog

### v2.1.0 (2024-12-01)
- Added analytics endpoint
- Improved response confidence scoring
- Enhanced error messages

### v2.0.0 (2024-11-15)
- Major personality update
- Added action suggestions
- Improved Indonesian language support

### v1.0.0 (2024-10-01)
- Initial API release
- Basic chat functionality
- System status endpoints

---

For additional support or questions about the API, contact the development team or check the [GitHub Issues](https://github.com/dasaraul/Pablos-Chat-AI/issues).