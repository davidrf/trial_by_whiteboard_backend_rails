# Trial By Whiteboard API (Rails)
[ ![Codeship Status for davidrf/trial_by_whiteboard_backend_rails](https://codeship.com/projects/a6d8f0a0-1b09-0134-453f-66ed86225da0/status?branch=master)](https://codeship.com/projects/159541)
[![Coverage Status](https://coveralls.io/repos/github/davidrf/trial_by_whiteboard_backend_rails/badge.svg?branch=master)](https://coveralls.io/github/davidrf/trial_by_whiteboard_backend_rails?branch=master)
[![Code Climate](https://codeclimate.com/github/davidrf/trial_by_whiteboard_backend_rails/badges/gpa.svg)](https://codeclimate.com/github/davidrf/trial_by_whiteboard_backend_rails)

## About
RESTful Rails 5 API for the Trial By Whiteboard application. Serves JSON
formatted data through the use of ActiveModel Serializers. Features access token
authentication implemented by using [`has_secure_password`][has-secure-password] and [warden][warden-gem].

[Application Storyboard][application-storyboard]

## API Documentation

### V1
In order to access the V1 resources of the API, please add an `Accept` header with the value of`application/vnd.trialbywhiteboard.herokuapp.com; version=1` in your requests.

Furthermore, if the endpoint requires authentication, then make sure to include
an `Authorization` header with the value of `Token
token=yourauthenticationtoken` where `yourauthenticationtoken` is the
value of the authentication token for a user.

#### Users
##### Create
```
POST /users HTTP/1.1
Host: trialbywhiteboardrailsapi.herokuapp.com
Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1
Content-Type: application/json

{
    "user": {
        "email": "pikachu@pokemon.com",
        "username": "pikachu",
        "password": "password1"
    }
}
```

Example cURL request:

```
curl -X POST -H "Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1" -H "Content-Type: application/json" -H -d '{
    "user": {
        "email": "pikachu@pokemon.com",
        "username": "pikachu",
        "password": "password1"
    }
}' "https://trialbywhiteboardrailsapi.herokuapp.com/users"
```

Example JSON response (pretty printed):

```
{
  "user": {
    "id": 2,
    "authenticationToken": "h6hwi4Dqj3BNm81ybjn3PBYK",
    "authenticationTokenExpiresAt": "2016-07-26T19:02:03.249Z",
    "email": "pikachu@pokemon.com",
    "username": "pikachu"
  }
}
```

Includes an authentication token which should be used in an `Authorization`
header for endpoints which require authentication. This authentication token
will will expire after a week.

#### Authentication Tokens
##### Create
```
POST /authentication_tokens HTTP/1.1
Host: trialbywhiteboardrailsapi.herokuapp.com
Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1
Content-Type: application/json

{
    "user": {
        "username": "pikachu",
        "password": "password1"
    }
}
```

Example cURL request:
```
curl -X POST -H "Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1" -H "Content-Type: application/json" -d '{
    "user": {
        "username": "pikachu",
        "password": "password1"
    }
}' "https://trialbywhiteboardrailsapi.herokuapp.com/authentication_tokens"
```

Example JSON response (pretty printed):
```
{
  "user": {
    "id": 2,
    "authenticationToken": "q8hTTPN1LzgadrZ7NcRCiko5",
    "authenticationTokenExpiresAt": "2016-07-26T19:37:21.315Z",
    "email": "pikachu@pokemon.com",
    "username": "pikachu"
  }
}
```

Creates a new authentication token for the user that will expire after a week.

##### Delete (Authentication Required)
```
DELETE /authentication_tokens HTTP/1.1
Host: trialbywhiteboardrailsapi.herokuapp.com
Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1
Authorization: Token token=eDC9EHrmhUV5nE9qoQonsiEc
```

Example cURL Request:
```
curl -X DELETE -H "Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1" -H "Authorization: Token token=eDC9EHrmhUV5nE9qoQonsiEc" "https://trialbywhiteboardrailsapi.herokuapp.com/authentication_tokens"
```

Returns a 204 HTTP Status (No Content)

#### Questions
##### Create (Authentication Required)
```
POST /questions HTTP/1.1
Host: trialbywhiteboardrailsapi.herokuapp.com
Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1
Authorization: Token token=LWxp5MgcAP7AqSQe9eDQdaGB
Content-Type: application/json

{
    "question": {
        "title": "how do Active Model Serializers work?",
        "body": "I have no idea how to use them...."
    }
}
```

Example cURL request:
```
curl -X POST -H "Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1" -H "Authorization: Token token=LWxp5MgcAP7AqSQe9eDQdaGB" -H "Content-Type: application/json" -d '{
    "question": {
        "title": "how do Active Model Serializers work?",
        "body": "I have no idea how to use them...."
    }
}' "https://trialbywhiteboardrailsapi.herokuapp.com/questions"
```

Example JSON response (pretty printed):
```
{
    "question": {
        "body": "I have no idea how to use them....",
        "id": 3,
        "title": "how do Active Model Serializers work?",
        "link": "https://trialbywhiteboardrailsapi.herokuapp.com/questions/3",
        "user": {
            "id": 2,
            "username": "pikachu"
        },
        "answers": []
    }
}
```

##### Read - Index
```
GET /questions HTTP/1.1
Host: trialbywhiteboardrailsapi.herokuapp.com
Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1
Cache-Control: no-cache
Postman-Token: 20fee30c-e03b-b9d0-f510-dffef68f4911
```

Example cURL request:
```
curl -X GET -H "Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1" "https://trialbywhiteboardrailsapi.herokuapp.com/questions"
```

Example JSON response (pretty printed):
```
{
    "questions": [
        {
            "body": "I have no idea how to use them....",
            "id": 3,
            "title": "how do Active Model Serializers work?",
            "link": "https://trialbywhiteboardrailsapi.herokuapp.com/questions/3",
            "user": {
                "id": 2,
                "username": "pikachu"
            },
            "answers": [
                {
                    "body": "Read the docs! They're awesome <3",
                    "id": 1,
                    "link": "https://trialbywhiteboardrailsapi.herokuapp.com/answers/1"
                }
            ]
        }
    ]
}
```
##### Read - Show
```
GET /questions/3 HTTP/1.1
Host: trialbywhiteboardrailsapi.herokuapp.com
Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1
Cache-Control: no-cache
Postman-Token: 38b0a491-6be6-6e1a-88db-ce642c9e98ac
```

Example cURL request:
```
curl -X GET -H "Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1" "https://trialbywhiteboardrailsapi.herokuapp.com/questions/3"
```

Example JSON response (pretty printed):
```
{
  "question": {
    "body": "I have no idea how to use them....",
    "id": 3,
    "title": "how do Active Model Serializers work?",
    "link": "https://trialbywhiteboardrailsapi.herokuapp.com/questions/3",
    "user": {
      "id": 2,
      "username": "pikachu"
    },
    "answers": [
      {
        "body": "Read the docs! They're awesome <3",
        "id": 1,
        "link": "https://trialbywhiteboardrailsapi.herokuapp.com/answers/1"
      }
    ]
  }
}
```


##### Update (Authentication Required)
```
PATCH /questions/3 HTTP/1.1
Host: trialbywhiteboardrailsapi.herokuapp.com
Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1
Authorization: Token token=LWxp5MgcAP7AqSQe9eDQdaGB
Content-Type: application/json
Cache-Control: no-cache
Postman-Token: d5090b26-68f0-ba31-83ec-6aa1fb794153

{
    "question": {
        "body": "I have no idea how to use them....should I read the docs?"
    }
}
```

Example cURL request:
```
curl -X PATCH -H "Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1" -H "Authorization: Token token=LWxp5MgcAP7AqSQe9eDQdaGB" -H "Content-Type: application/json" -d '{
    "question": {
        "body": "I have no idea how to use them....should I read the docs?"
    }
}' "https://trialbywhiteboardrailsapi.herokuapp.com/questions/3"
```

Returns a 204 HTTP Status (No Content)

##### Delete (Authentication Required)
```
DELETE /questions/3 HTTP/1.1
Host: trialbywhiteboardrailsapi.herokuapp.com
Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1
Authorization: Token token=LWxp5MgcAP7AqSQe9eDQdaGB
```

Example cURL request:
```
curl -X DELETE -H "Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1" -H "Authorization: Token token=LWxp5MgcAP7AqSQe9eDQdaGB" "https://trialbywhiteboardrailsapi.herokuapp.com/questions/3"
```

Returns a 204 HTTP Status (No Content)

#### Answers
##### Create (Authentication Required)
```
POST /questions/3/answers HTTP/1.1
Host: trialbywhiteboardrailsapi.herokuapp.com
Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1
Authorization: Token token=LWxp5MgcAP7AqSQe9eDQdaGB
Content-Type: application/json

{
    "answer": {
        "body": "Read the docs! They're awesome <3"
    }
}
```

Example cURL request:
```
curl -X POST -H "Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1" -H "Authorization: Token token=LWxp5MgcAP7AqSQe9eDQdaGB" -H "Content-Type: application/json" -H -d '{
    "answer": {
        "body": "Read the docs! They're awesome <3"
    }
}' "https://trialbywhiteboardrailsapi.herokuapp.com/questions/3/answers"
```

Example JSON response (pretty printed):
```
{
  "answer": {
    "body": "Read the docs! They're awesome <3",
    "id": 1,
    "link": "https://trialbywhiteboardrailsapi.herokuapp.com/answers/1",
    "question": {
      "body": "I have no idea how to use them....",
      "id": 3,
      "title": "how do Active Model Serializers work?",
      "link": "https://trialbywhiteboardrailsapi.herokuapp.com/questions/3"
    },
    "user": {
      "id": 2,
      "username": "pikachu"
    }
  }
}
```
##### Update (Authentication Required)
```
PATCH /answers/1 HTTP/1.1
Host: trialbywhiteboardrailsapi.herokuapp.com
Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1
Authorization: Token token=LWxp5MgcAP7AqSQe9eDQdaGB
Content-Type: application/json

{
    "answer": {
        "body": "Read the docs! They're the best! <3 <3"
    }
}
```

Example cURL request:
```
curl -X PATCH -H "Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1" -H "Authorization: Token token=LWxp5MgcAP7AqSQe9eDQdaGB" -H "Content-Type: application/json" -d '{
    "answer": {
        "body": "Read the docs! They're the best! <3 <3"
    }
}' "https://trialbywhiteboardrailsapi.herokuapp.com/answers/1"
```

Returns a 204 HTTP Status (No Content)

##### Delete (Authentication Required)
```
DELETE /answers/1 HTTP/1.1
Host: trialbywhiteboardrailsapi.herokuapp.com
Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1
Authorization: Token token=LWxp5MgcAP7AqSQe9eDQdaGB
Cache-Control: no-cache
Postman-Token: dbbd35cf-f566-64a1-86b1-61bdd2440c1b
```

Example cURL request:
```
curl -X DELETE -H "Accept: application/vnd.trialbywhiteboard.herokuapp.com; version=1" -H "Authorization: Token token=LWxp5MgcAP7AqSQe9eDQdaGB" "https://trialbywhiteboardrailsapi.herokuapp.com/answers/1"
```

Returns a 204 HTTP Status (No Content)

## Setting Up
Run the following commands to quickly get the server up and running locally

```
$ git clone https://github.com/davidrf/trial_by_whiteboard_backend_rails.git
$ cd trial_by_whiteboard_backend_rails
$ bundle install
$ bundle exec rails db:create
$ bundle exec rails db:migrate
$ bundle exec rails server
```

[application-storyboard]: https://trello.com/b/FE2pnJkO/trial-by-whiteboard-backend-rails
[has-secure-password]: http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html
[warden-gem]: https://github.com/hassox/warden/wiki
