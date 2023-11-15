-- 8 --> Fecha registro 
create table film_insertion_date (
  film_id INT,
  insertion_date TIMESTAMP,
  PRIMARY KEY (film_id),
  FOREIGN KEY (film_id) REFERENCES film(film_id)
);

CREATE OR REPLACE FUNCTION save_insertion_date()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO film_insertion_date (film_id, insertion_date)
    VALUES (NEW.film_id, CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_save_insertion_date
AFTER INSERT ON film
FOR EACH ROW
EXECUTE FUNCTION save_insertion_date();

-- 9 --> Fecha eliminacion
create table film_erase_date (
  film_id INT,
  erase_date TIMESTAMP,
  PRIMARY KEY (film_id),
  FOREIGN KEY (film_id) REFERENCES film(film_id)
);

CREATE OR REPLACE FUNCTION guardar_erase_date()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO film_erase_date (film_id, erase_date)
    VALUES (OLD.film_id, CURRENT_TIMESTAMP);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_guardar_erase_date
AFTER DELETE ON film
FOR EACH ROW
EXECUTE FUNCTION guardar_erase_date();
