DROP DATABASE IF EXISTS salon;
CREATE DATABASE salon;
\c salon
CREATE TABLE customers(
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR UNIQUE NOT NULL,
  name VARCHAR NOT NULL
);
CREATE TABLE services(
  service_id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL
);
CREATE TABLE appointments(
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL REFERENCES customers(customer_id),
  service_id INT NOT NULL REFERENCES services(service_id),
  time VARCHAR NOT NULL
);
INSERT INTO services(name) VALUES ('cut'), ('color'), ('perm'), ('style'), ('trim');