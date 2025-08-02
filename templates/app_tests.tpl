#testing script
#!/bin/bash

#HEALTH CHECK
curl "${db_endpoint}/health"

#POST users
curl -v -X POST "${db_endpoint}/users" \
-H "Content-Type: application/json" \
-d '{"name":"Helena","city":"Porto","age":30}'

curl -v -X POST "${db_endpoint}/users" \
-H "Content-Type: application/json" \
-d '{"name":"Pedro","city":"Lisboa","age":26}'

curl -v -X POST "${db_endpoint}/users" \
-H "Content-Type: application/json" \
-d '{"name":"Tiago","city":"Sintra","age":35}'


#GET users
curl "${db_endpoint}/users"