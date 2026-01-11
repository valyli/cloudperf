-- 插入基础国家数据
INSERT IGNORE INTO country (code, name, continent_code, continent_name) VALUES
('US', 'United States', 'NA', 'North America'),
('CN', 'China', 'AS', 'Asia'),
('JP', 'Japan', 'AS', 'Asia'),
('DE', 'Germany', 'EU', 'Europe'),
('GB', 'United Kingdom', 'EU', 'Europe'),
('SG', 'Singapore', 'AS', 'Asia'),
('AU', 'Australia', 'OC', 'Oceania'),
('BR', 'Brazil', 'SA', 'South America'),
('CA', 'Canada', 'NA', 'North America'),
('IN', 'India', 'AS', 'Asia');

-- 插入基础ASN数据
INSERT IGNORE INTO asn (asn, country_code, type, name, domain) VALUES
(16509, 'US', 'hosting', 'Amazon.com, Inc.', 'amazon.com'),
(15169, 'US', 'hosting', 'Google LLC', 'google.com'),
(8075, 'US', 'hosting', 'Microsoft Corporation', 'microsoft.com'),
(13335, 'US', 'hosting', 'Cloudflare, Inc.', 'cloudflare.com'),
(14061, 'US', 'hosting', 'DigitalOcean, LLC', 'digitalocean.com'),
(20940, 'JP', 'hosting', 'Akamai International B.V.', 'akamai.com'),
(4134, 'CN', 'isp', 'China Telecom Corporation Limited', 'chinatelecom.com.cn'),
(9808, 'CN', 'isp', 'China Mobile Communications Group Co., Ltd.', 'chinamobile.com'),
(4837, 'CN', 'isp', 'China Unicom Backbone', 'chinaunicom.com'),
(3462, 'TW', 'isp', 'Data Communication Business Group', 'hinet.net');

-- 插入基础城市数据
INSERT IGNORE INTO city (id, asn, country_code, name, region, latitude, longitude) VALUES
(1, 16509, 'US', 'Virginia', 'Virginia', 38.13, -78.45),
(2, 16509, 'US', 'Oregon', 'Oregon', 44.931, -123.029),
(3, 16509, 'US', 'California', 'California', 37.354, -121.955),
(4, 16509, 'JP', 'Tokyo', 'Tokyo', 35.676, 139.650),
(5, 16509, 'SG', 'Singapore', 'Singapore', 1.290, 103.851),
(6, 16509, 'AU', 'Sydney', 'New South Wales', -33.868, 151.207),
(7, 16509, 'DE', 'Frankfurt', 'Hesse', 50.110, 8.682),
(8, 16509, 'GB', 'London', 'England', 51.507, -0.127),
(9, 15169, 'US', 'Virginia', 'Virginia', 38.13, -78.45),
(10, 15169, 'US', 'California', 'California', 37.354, -121.955);

-- 插入基础IP段数据 (示例AWS和Google的一些IP段)
INSERT IGNORE INTO iprange (start_ip, end_ip, city_id) VALUES
(INET_ATON('3.208.0.0'), INET_ATON('3.208.255.255'), 1),    -- AWS us-east-1
(INET_ATON('44.224.0.0'), INET_ATON('44.224.255.255'), 2),  -- AWS us-west-2
(INET_ATON('13.52.0.0'), INET_ATON('13.52.255.255'), 3),    -- AWS us-west-1
(INET_ATON('13.208.0.0'), INET_ATON('13.208.255.255'), 4),  -- AWS ap-northeast-3
(INET_ATON('52.220.0.0'), INET_ATON('52.220.255.255'), 5),  -- AWS ap-southeast-1
(INET_ATON('3.104.0.0'), INET_ATON('3.104.255.255'), 6),    -- AWS ap-southeast-2
(INET_ATON('3.120.0.0'), INET_ATON('3.120.255.255'), 7),    -- AWS eu-central-1
(INET_ATON('18.130.0.0'), INET_ATON('18.130.255.255'), 8),  -- AWS eu-west-2
(INET_ATON('8.8.8.0'), INET_ATON('8.8.8.255'), 9),         -- Google DNS
(INET_ATON('8.8.4.0'), INET_ATON('8.8.4.255'), 10);        -- Google DNS

-- 插入一些可ping的IP
INSERT IGNORE INTO pingable (ip, city_id, lastresult) VALUES
(INET_ATON('8.8.8.8'), 9, 1),
(INET_ATON('8.8.4.4'), 10, 1),
(INET_ATON('1.1.1.1'), 1, 1);