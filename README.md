
# BUILD MASTER-MASTER REPLICATION via Docker

1. Create .env file from dist: `cp .env.dist .env`

2. Build, create & run containers: `docker-compose up -d`

3. Set up mariadb:

```bash
docker-compose exec db1 ./opt/scripts/setup.sh db1 db2 1234
docker-compose exec db2 ./opt/scripts/setup.sh db2 db1 1234
```

4. Run replication:

```bash
docker-compose exec db1 mysql -u root -p1234 -e "start slave;"
docker-compose exec db2 mysql -u root -p1234 -e "start slave;"
```

5. Go to mysql (_db1_): `docker-compose exec db1 mysql -u root -p1234`

6. Check correctness: 

- on db1

```sql
CREATE DATABASE test;
USE test;
```

- on db2

```sql
SHOW DATABASES;
USE test;
```

- on db1

```sql
CREATE TABLE test1 (id INT AUTO_INCREMENT, PRIMARY KEY(id));
```

- on db2

```sql
USE test;
SHOW TABLES;
```

7. It's all, enjoy!
