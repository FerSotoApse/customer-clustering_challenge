-- database and table structure for Omya dataset

# DROP DATABASE omya_ddbb;
CREATE DATABASE omya_ddbb;
USE omya_ddbb;

# df_mat_type
CREATE TABLE material_types(
    material VARCHAR(15) PRIMARY KEY,
    material_type ENUM('Material_Type_1', 'Material_Type_2')
	)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    
# df_customer
CREATE TABLE customers(
	customer VARCHAR(50) PRIMARY KEY
	)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

# df_plant_tp
CREATE TABLE plant_types(
	plant VARCHAR(10) PRIMARY KEY,
    plant_types ENUM('Plant_Type_1', 'Plant_Type_2', 'Plant_Type_3', 'Plant_Type_4')
	)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    
# df_key_acc
CREATE TABLE key_accounts(
	soldto VARCHAR(50) NOT NULL,
    ship_to_customer VARCHAR(20) PRIMARY KEY,
    key_account CHAR(15) NOT NULL,
    key_account_grouper VARCHAR(10),
    CONSTRAINT fk_customer_keyacc
		FOREIGN KEY(soldto) REFERENCES customers(customer)
		ON DELETE CASCADE
	)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

# df_brand
CREATE TABLE brands(
	material VARCHAR(15) NOT NULL,
    brand VARCHAR(15),
    sub_brand VARCHAR(15),
    CONSTRAINT fk_material_brand
		FOREIGN KEY(material) REFERENCES material_types(material)
        ON DELETE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

# df_mat_attr
CREATE TABLE product_attr(
	material VARCHAR(15) NOT NULL,
    product_type VARCHAR(20),
    product_subtype VARCHAR(25),
	CONSTRAINT fk_material_product
		FOREIGN KEY(material) REFERENCES material_types(material)
        ON DELETE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

# df_plant_src
CREATE TABLE plant_sourcing(
	material VARCHAR(15) NOT NULL,
    sourcing_plant CHAR(9) NOT NULL,
    sourcing_vendor CHAR(20),
    CONSTRAINT fk_material_plantsrc
		FOREIGN KEY(material) REFERENCES material_types(material)
        ON DELETE CASCADE,
	CONSTRAINT fk_plant
		FOREIGN KEY(sourcing_plant) REFERENCES plant_types(plant)
        ON DELETE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    
# df_mkt_pos
CREATE TABLE c_market_position(
	soldto VARCHAR(50) NOT NULL,
    market_position ENUM(
		'Innovative & Faster Growing than Market',
        'Faster Growing than Market',
        'Innovative',
        'Niche Player',
        'Market Follower'),
    CONSTRAINT fk_customer_mktpos
		FOREIGN KEY(soldto) REFERENCES customers(customer)
		ON DELETE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

# df_relation
CREATE TABLE c_relationship(
	soldto VARCHAR(50) NOT NULL,
    relationship ENUM(
		'Transactional',
        'Pure Business',
        'Advanced Business Ties',
        'Opportunistic',
        'Partnership'),
    CONSTRAINT fk_customer_relationship
		FOREIGN KEY(soldto) REFERENCES customers(customer)
		ON DELETE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

# df_country
CREATE TABLE countries(
	soldto VARCHAR(50) NOT NULL,
    country VARCHAR(20),
    ship_to_customer VARCHAR(20) NOT NULL,
    CONSTRAINT fk_customer_country
		FOREIGN KEY(soldto) REFERENCES customers(customer)
		ON DELETE CASCADE,
    CONSTRAINT fk_invoice_country
		FOREIGN KEY(ship_to_customer) REFERENCES key_accounts(ship_to_customer)
		ON DELETE CASCADE    
	)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

# df_c_market
CREATE TABLE customer_types(
	soldto VARCHAR(50) NOT NULL,
    customer_type VARCHAR(20),
    ship_to_customer VARCHAR(20) NOT NULL,
    CONSTRAINT fk_customer_ctype
		FOREIGN KEY(soldto) REFERENCES customers(customer)
		ON DELETE CASCADE,
    CONSTRAINT fk_invoice_ctype
		FOREIGN KEY(ship_to_customer) REFERENCES key_accounts(ship_to_customer)
		ON DELETE CASCADE  
	)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    
# df_sales
CREATE TABLE sales(
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    ship_to_customer VARCHAR(20) NOT NULL,
    material VARCHAR(15) NOT NULL,
    window_tag ENUM(
		'Null', 'WindowQ1', 'WindowQ2', 'WindowQ3', 'WindowQ4') DEFAULT "Null",
    other_data VARCHAR(10) DEFAULT "Not Apply",
    month_ ENUM('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'),
    sales_qty_2024 DECIMAL(8,2),
    sales_qty_2023 DECIMAL(8,2),
    sales_qty_2022 DECIMAL(8,2),
    sales_qty_2021 DECIMAL(8,2),
    net_sales_2024 DECIMAL(50,2),
    net_sales_2023 DECIMAL(50,2),
    net_sales_2022 DECIMAL(50,2),
    net_sales_2021 DECIMAL(50,2),
    p2_2024 DECIMAL(50,2),
    p2_2023 DECIMAL(50,2),
    p2_2022 DECIMAL(50,2),
    p2_2021 DECIMAL(50,2),
    CONSTRAINT fk_invoice_sales
		FOREIGN KEY(ship_to_customer) REFERENCES key_accounts(ship_to_customer)
		ON DELETE CASCADE,
	CONSTRAINT fk_material_sales
		FOREIGN KEY(material) REFERENCES material_types(material)
        ON DELETE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;