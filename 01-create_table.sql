-- DDL -> data definition language (definicion de la tabla)

CREATE TABLE users (
    id SERIAL,
    name VARCHAR(10) UNIQUE
);


-- y algo mas avanzado:

CREATE TABLE users (
    "id" varchar(36) NOT NULL DEFAULT gen_random_uuid(), -- esta es una funcion propia de Postgres
    "first_name" varchar(100) NOT NULL,
    "last_name" varchar(100) NOT NULL,
    "email" varchar(100) NOT NULL UNIQUE,
    "last_connection" varchar(100) NOT NULL,
    "country" varchar(100) NOT NULL,
    "website" varchar(100) NOT NULL,
    "username" varchar(100) NOT NULL UNIQUE,
    "followers" int4 NOT NULL,
    "following" int4 NOT NULL,
    PRIMARY KEY ("id")
);