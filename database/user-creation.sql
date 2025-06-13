-- SQL script for creating management account

-- user
CREATE USER admin @localhost IDENTIFIED BY 'admin1234'
GRANT ALL PRIVILEGES ON pjtdb.* to admin @localhost;

COMMIT;