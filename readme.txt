Setup Application using maven
--------------------------------------
Install latest maven

Going to create maven project by following command:

mvn archetype:generate -DgroupId=com.h2 -DartifactId=book-search -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

It setup basic structure with java application.

mvn clean -> The removal of all the artifacts that if has been created.
mvn install -> compile the code and create the new artifacts.

To run the maven main class:
mvn exec:java -Dexec.mainClass="com.h2.App"


Setup Springboot Application
--------------------------------------
Include springboot dependencies
expore one simple API.


Going to setup Docker 
----------------------

CMD > Create a docker-compose.yml file that hosts a latest PostgreSQL database.
The container name should be library-db, the database name should be library,
the user is admin and password is admin123.
We also need to expose the db to the local port 5432.

docker compose up -d -> going to up the container.

docker compose down -v -> going to down the container.

docker ps -> list down the docker images

This file allow to go the PostgreSQL container DB and run the cmd inside DB.

docker exec -it library-db psql -U admin library

Adding this line to the docker compose file , after preparing the schema in create_schema.sql :
./db/create_tables.sql:/docker-entrypoint-initdb.d/init.sql

The above line does, when the container starts , it look file and put the schema in the container.
\l -> list down all the database in your DB container.

\d -> list the table

\d  authors; -> show the schema mapping of author

Link pgAdmin with PostgreSQL
----------------------------------------------
Going to link our data with pg admin ( UI ) , our database is in docker container, we use docker 
image of pgadmin


To pull some image locally :

docker pull dpage/pgadmin4


mustafa@mustafa-ThinkPad-E580:~/Documents/Coding/Projects/book-search$ docker compose up -d
[+] Running 3/3
 ✔ Network book-search_default      Created                                                                                                                                        0.4s 
 ✔ Volume book-search_library-data  Created                                                                                                                                        0.1s 
 ✔ Container library-db             Started  

Note : Eventually we will connect pgAdmin with the above create image docker create by default (Network book-search_default )

First pull the image locally : docker pull dpage/pgadmin4

After that linking task

https://www.pgadmin.org/docs/pgadmin4/latest/container_deployment.html#examples

This is how you start pdadmin , inside docker container.

docker run -p 80:80 \
    -e 'PGADMIN_DEFAULT_EMAIL=user@domain.com' \
    -e 'PGADMIN_DEFAULT_PASSWORD=SuperSecret' \
    -d dpage/pgadmin4

Append change in the above command 

docker run -p 80:80 -e 'PGADMIN_DEFAULT_EMAIL=user@domain.com' -e 'PGADMIN_DEFAULT_PASSWORD=SuperSecret' \
    --name pgadmin --network book-search_default -d dpage/pgadmin4

After above command the another image is created , in which pgadmin is up on port 8 locally.

You can access in the browser -> localhost:80 ( You will see the pgadmin UI)

pgAdmin UI
----------
ask for hostName (where database installed) : host is installed is inside container , name is library-db

How we know that is libray-db :
mustafa@mustafa-ThinkPad-E580:~/Documents/Coding/Projects/book-search$ docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS          PORTS                                          NAMES
e47a66e406e7   dpage/pgadmin4   "/entrypoint.sh"         27 seconds ago   Up 25 seconds   0.0.0.0:80->80/tcp, [::]:80->80/tcp, 443/tcp   pgadmin
c003f7b0943f   postgres:17      "docker-entrypoint.s…"   16 minutes ago   Up 16 minutes   0.0.0.0:5433->5432/tcp, [::]:5433->5432/tcp    library-db

after login on pdadmin , the insert the data in the database :

INSERT INTO public.books(
	book_id, title, rating, description, isbn, book_format, edition, pages, publisher, publication_date, first_publisher_date, liked_percent, price)
	VALUES 
	(5, 'Lisan-ul-Quran', 5.0, 'Comprehensive information regarding Quran', 3543534543, 'Handcover', '1st Edition', 1000, 'Aamir Sohail', '2020-01-01', '2020-01-01', 89.75, 89.99),
	(6, 'Data structure & Algorithems', 2.0, 'Comprehensive information regarding data structure and quality understanding of algorithems', 234324234324, 'Paperback', '4st Edition', 464, 'Pierce Joy', '2005-04-01', '2000-08-01', 45.75, 22.99),
	(7, 'Clean Code', 3.0, 'Better understanding of writing bug free and flexible code', 3433434343, 'Paperback', '2st Edition', 600, 'Jamed Herly', '1991-09-23', '1989-03-15', 23.75, 54.99);



Now need to test full search index :


ALTER TABLE books ADD COLUMN search_vector tsvector; // adding new column , where the index will be stored.

After that populate the data (search index) in this column.

SELECT * FROM public.books;
ALTER TABLE books ADD COLUMN search_vector tsvector;


UPDATE books SET search_vector = 
    setweight(to_tsvector('english', coalesce(title,'')), 'A') ||
    setweight(to_tsvector('english', coalesce(description,'')), 'B') ||
    setweight(to_tsvector('english', coalesce(isbn,'')), 'C');



Now further we need to insert bulk data into the schema , by followin 3 steps:
1. Download
2. Parse CSV 
3. Insert in DB

