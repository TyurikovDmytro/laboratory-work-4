CREATE TABLE clients (
    client_id INT AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),

    CONSTRAINT pk_clients PRIMARY KEY (client_id),
    CONSTRAINT chk_clients_email CHECK (
        email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$'
    ),
    CONSTRAINT chk_clients_phone CHECK (
        phone REGEXP '^\\+?[0-9]{10,15}$'
    )
);

CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT,
    client_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50),
    area_m2 NUMERIC(6,2),
    target_lux NUMERIC(6,2),

    CONSTRAINT pk_rooms PRIMARY KEY (room_id),
    CONSTRAINT fk_rooms_client FOREIGN KEY (client_id)
        REFERENCES clients(client_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_rooms_area CHECK (area_m2 > 0),
    CONSTRAINT chk_rooms_lux CHECK (target_lux > 0)
);

CREATE TABLE light_sensors (
    sensor_id INT AUTO_INCREMENT,
    room_id INT NOT NULL,
    sensor_code VARCHAR(50) NOT NULL UNIQUE,
    last_lux_value NUMERIC(8,2),
    last_measurement_at TIMESTAMP NOT NULL,

    CONSTRAINT pk_light_sensors PRIMARY KEY (sensor_id),
    CONSTRAINT fk_light_sensors_room FOREIGN KEY (room_id)
        REFERENCES rooms(room_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_sensor_code CHECK (
        sensor_code REGEXP '^SEN-[0-9]{4}$'
    )
);

CREATE TABLE light_devices (
    device_id INT AUTO_INCREMENT,
    room_id INT NOT NULL,
    device_code VARCHAR(50) NOT NULL UNIQUE,
    power_watt NUMERIC(6,2),
    state VARCHAR(10) NOT NULL,
    brightness_percent INT,

    CONSTRAINT pk_light_devices PRIMARY KEY (device_id),
    CONSTRAINT fk_light_devices_room FOREIGN KEY (room_id)
        REFERENCES rooms(room_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_state CHECK (state IN ('ON', 'OFF')),
    CONSTRAINT chk_power CHECK (power_watt > 0),
    CONSTRAINT chk_brightness CHECK (brightness_percent BETWEEN 0 AND 100)
);

CREATE TABLE measurements (
    measurement_id INT AUTO_INCREMENT,
    sensor_id INT NOT NULL,
    lux_value NUMERIC(8,2) NOT NULL,
    measured_at TIMESTAMP NOT NULL,

    CONSTRAINT pk_measurements PRIMARY KEY (measurement_id),
    CONSTRAINT fk_measurements_sensor FOREIGN KEY (sensor_id)
        REFERENCES light_sensors(sensor_id)
        ON DELETE CASCADE
);

CREATE TABLE scenarios (
    scenario_id INT AUTO_INCREMENT,
    room_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    mode VARCHAR(20) NOT NULL,

    CONSTRAINT pk_scenarios PRIMARY KEY (scenario_id),
    CONSTRAINT fk_scenarios_room FOREIGN KEY (room_id)
        REFERENCES rooms(room_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_mode CHECK (
        mode IN ('comfort', 'safe', 'economy', 'custom')
    )
);

CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT,
    client_id INT NOT NULL,
    message_text VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    severity VARCHAR(10),

    CONSTRAINT pk_notifications PRIMARY KEY (notification_id),
    CONSTRAINT fk_notifications_client FOREIGN KEY (client_id)
        REFERENCES clients(client_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_severity CHECK (
        severity IN ('info', 'warning', 'alert')
    )
);
