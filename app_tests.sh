#testing script
#!/bin/bash

#HEALTH CHECK
curl "my-alb-1073400262.eu-west-2.elb.amazonaws.com/health"
echo""

#POST users
curl -X POST "my-alb-1073400262.eu-west-2.elb.amazonaws.com/users" \
-H "Content-Type: application/json" \
-d '{"name":"Helena","city":"Porto","age":30}'
echo""

curl -X POST "my-alb-1073400262.eu-west-2.elb.amazonaws.com/users" \
-H "Content-Type: application/json" \
-d '{"name":"Pedro","city":"Lisboa","age":26}'
echo""

curl -X POST "my-alb-1073400262.eu-west-2.elb.amazonaws.com/users" \
-H "Content-Type: application/json" \
-d '{"name":"Tiago","city":"Sintra","age":35}'
echo""

#GET users
curl "my-alb-1073400262.eu-west-2.elb.amazonaws.com/users"
echo""