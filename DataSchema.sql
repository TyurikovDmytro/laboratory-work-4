CREATE TABLE clients (
    client_id INT AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    PRIMARY KEY (client_id)
);

CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT,
    client_id INT NOT NULL,
    name VARCHAR(100),
    type VARCHAR(50),
    area_m2 NUMERIC(6,2),
    target_lux NUMERIC(6,2),
    PRIMARY KEY (room_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

CREATE TABLE light_sensors (
    sensor_id INT AUTO_INCREMENT,
    room_id INT,
    sensor_code VARCHAR(50),
    last_lux_value NUMERIC(8,2),
    last_measurement_at TIMESTAMP,
    PRIMARY KEY (sensor_id)
);

CREATE TABLE light_devices(
device_id INT AUTO_INCREMENT,
room_id INT,
device_code VARCHAR(50),
power_watt NUMERIC(6,2),
state VARCHAR(10),
brightness_percent INT,
PRIMARY KEY (device_id)
);

CREATE TABLE measurements (
    measurement_id INT AUTO_INCREMENT,
    sensor_id INT,
    lux_value NUMERIC(8,2),
    measured_at TIMESTAMP,
    PRIMARY KEY (measurement_id)
);

CREATE TABLE scenarios (
    scenario_id INT AUTO_INCREMENT,
    room_id INT,
    name VARCHAR(100),
    mode VARCHAR(20),
    PRIMARY KEY (scenario_id)
);

CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT,
    client_id INT,
    message_text VARCHAR(255),
    created_at TIMESTAMP,
    severity VARCHAR(10),
    PRIMARY KEY (notification_id)
);
