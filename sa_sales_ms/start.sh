docker-compose build
docker-compose run --rm sa_sales_ms rails db:create
docker-compose run --rm sa_sales_ms rails db:migrate
docker-compose up