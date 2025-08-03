#testing script
#!/bin/bash

#HEALTH CHECK
curl -v "${alb_dns}/health"
echo""

#POST users
curl -X POST "${alb_dns}/users" \
-H "Content-Type: application/json" \
-d '{"name":"Helena","city":"Porto","age":30}'
echo""

curl -X POST "${alb_dns}/users" \
-H "Content-Type: application/json" \
-d '{"name":"Pedro","city":"Lisboa","age":26}'
echo""

curl -X POST "${alb_dns}/users" \
-H "Content-Type: application/json" \
-d '{"name":"Tiago","city":"Sintra","age":35}'
echo""

#GET users
curl "${alb_dns}/users"
echo""