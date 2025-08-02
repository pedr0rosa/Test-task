#!/bin/bash

#HEALTH CHECK
curl "my-alb-2037972088.eu-west-2.elb.amazonaws.com/health"

#POST users
curl -v -X POST "my-alb-2037972088.eu-west-2.elb.amazonaws.com/users" \
-H "Content-Type: application/json" \
-d '{"name":"Helena","city":"Porto","age":30}'

curl -v -X POST "my-alb-2037972088.eu-west-2.elb.amazonaws.com/users" \
-H "Content-Type: application/json" \
-d '{"name":"Pedro","city":"Lisboa","age":26}'

curl -v -X POST "my-alb-2037972088.eu-west-2.elb.amazonaws.com/users" \
-H "Content-Type: application/json" \
-d '{"name":"Tiago","city":"Sintra","age":35}'


#GET users
curl "my-alb-2037972088.eu-west-2.elb.amazonaws.com/users"
