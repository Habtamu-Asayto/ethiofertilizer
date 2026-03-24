CREATE TABLE IF NOT EXISTS adjusted_fert_demand_region (
  afdr_id SERIAL PRIMARY KEY,
  year VARCHAR(12),
  region VARCHAR(50),
  zone VARCHAR(30),
  fert_type VARCHAR(30) NOT NULL,
  adjusted_amt VARCHAR(20),
  adj_time VARCHAR(28),
  adjby VARCHAR(18)
); 
 
CREATE TABLE IF NOT EXISTS agri_organizations (
  orgid SERIAL PRIMARY KEY,
  orgname VARCHAR(200)  NOT NULL,
  abbreviation VARCHAR(10)  NOT NULL,
  website VARCHAR(255)  NOT NULL,
  facebook VARCHAR(200)  NOT NULL,
  logo VARCHAR(255)  NOT NULL,
  address VARCHAR(255)  NOT NULL,
  regby VARCHAR(70)  NOT NULL,
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ; 
-- bid_documents
CREATE TABLE IF NOT EXISTS bid_documents (
  id SERIAL PRIMARY KEY,
  tender_id INTEGER,
  company_id INTEGER,
  document_type VARCHAR(150),
  received_by VARCHAR(30),
  received_date TIMESTAMP
);

-- bid_purchases
CREATE TABLE IF NOT EXISTS bid_purchases (
  id SERIAL PRIMARY KEY,
  bid_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  amount_paid DECIMAL(10,2) NOT NULL,
  payment_ref VARCHAR(200),
  status VARCHAR(10) DEFAULT 'pending'
    CHECK (status IN ('pending','paid','failed')),
  purchased_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  -- FOREIGN KEY (bid_id) REFERENCES bids(bev_id)
);

-- bid_receival_minutes
CREATE TABLE IF NOT EXISTS bid_receival_minutes (
  minute_id SERIAL PRIMARY KEY,
  tender_id INTEGER NOT NULL,
  bid_opening_date TIMESTAMP NOT NULL,
  location VARCHAR(255),
  chairperson VARCHAR(150),
  secretary VARCHAR(150),
  member1 VARCHAR(150),
  member2 VARCHAR(150),
  member3 VARCHAR(150),
  company_name VARCHAR(255),
  document_complete VARCHAR(3) DEFAULT 'Yes'
    CHECK (document_complete IN ('Yes','No')),
  missing_documents TEXT,
  bid_amount DECIMAL(18,2),
  bid_currency VARCHAR(10) DEFAULT 'ETB',
  received_by VARCHAR(150),
  remarks TEXT,
  signed_copy VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- bid_team
CREATE TABLE IF NOT EXISTS bid_team (
  team_id SERIAL PRIMARY KEY,
  tender_ref VARCHAR(100) NOT NULL,
  team_name VARCHAR(150) NOT NULL,
  delegation_letter VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- bid_team_members
CREATE TABLE IF NOT EXISTS bid_team_members (
  member_id SERIAL PRIMARY KEY,
  team_id INTEGER NOT NULL,
  member_name VARCHAR(150) NOT NULL,
  organization VARCHAR(150) NOT NULL,
  role VARCHAR(100) NOT NULL,
  email VARCHAR(150),
  photo VARCHAR(255)
  -- FOREIGN KEY (team_id) REFERENCES bid_team(team_id)
);

-- bid_uploads
CREATE TABLE IF NOT EXISTS bid_uploads (
  id SERIAL PRIMARY KEY,
  tender_id VARCHAR(30),
  supplier_id INTEGER,
  file_path VARCHAR(255),
  upload_date TIMESTAMP
);

-- bids
CREATE TABLE IF NOT EXISTS bids (
  bev_id SERIAL PRIMARY KEY,
  tender_id INTEGER NOT NULL,
  company VARCHAR(200),
  evaluator VARCHAR(30),
  price_score VARCHAR(2),
  tech_score VARCHAR(2),
  experience_score VARCHAR(2),
  total_score VARCHAR(3),
  remarks VARCHAR(255),
  evaluated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- crop_category
CREATE TABLE IF NOT EXISTS crop_category (
  cat_id SERIAL PRIMARY KEY,
  crop_category VARCHAR(80) NOT NULL
);

-- crop_desc
CREATE TABLE IF NOT EXISTS crop_desc (
  cid SERIAL PRIMARY KEY,
  crop VARCHAR(50),
  crop_a VARCHAR(30),
  crop_category VARCHAR(25),
  crop_image VARCHAR(255)
);

-- crop_list
CREATE TABLE IF NOT EXISTS crop_list (
  clid SERIAL PRIMARY KEY,
  crop_category INTEGER NOT NULL,
  crop VARCHAR(50) NOT NULL,
  urea_high_kg_ha INTEGER,
  dap_high_kg_ha INTEGER,
  urea_medium_kg_ha INTEGER,
  dap_medium_kg_ha INTEGER,
  urea_low_kg_ha INTEGER,
  dap_low_kg_ha INTEGER,
  active INTEGER DEFAULT 0
  -- FOREIGN KEY (crop_category) REFERENCES crop_category(cat_id)
);

-- current_year
CREATE TABLE IF NOT EXISTS current_year (
  cyid SERIAL PRIMARY KEY,
  current_year VARCHAR(4),
  active INTEGER DEFAULT 0
);

-- da_data
CREATE TABLE IF NOT EXISTS da_data (
  did SERIAL PRIMARY KEY,
  salutation VARCHAR(10),
  name VARCHAR(15),
  father_name VARCHAR(17),
  gf_name VARCHAR(15),
  sex VARCHAR(7),
  mobile VARCHAR(25),
  academic_level VARCHAR(14),
  filed_of_study VARCHAR(53),
  job_position VARCHAR(49),
  region VARCHAR(22),
  zone VARCHAR(16),
  woreda VARCHAR(20),
  kebele VARCHAR(42)
);

-- data_collector
CREATE TABLE IF NOT EXISTS data_collector (
  dcid SERIAL PRIMARY KEY,
  fullname VARCHAR(50) NOT NULL,
  mobile VARCHAR(50) NOT NULL,
  email VARCHAR(60) NOT NULL,
  password VARCHAR(70) NOT NULL,
  reg_date VARCHAR(40) NOT NULL,
  approval INTEGER NOT NULL
);

-- data_institutions
CREATE TABLE IF NOT EXISTS data_institutions (
  id SERIAL PRIMARY KEY,
  info_source VARCHAR(60) NOT NULL,
  org VARCHAR(70) NOT NULL,
  reg_by VARCHAR(70) NOT NULL,
  attachment VARCHAR(255) NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- delete_pcs_final
CREATE TABLE IF NOT EXISTS delete_pcs_final (
  delpcid SERIAL PRIMARY KEY,
  pcid INTEGER NOT NULL,
  union_id VARCHAR(50),
  cooperative_name VARCHAR(55),
  region VARCHAR(10),
  zone VARCHAR(10),
  woreda VARCHAR(25),
  kebele VARCHAR(29),
  destination VARCHAR(6) NOT NULL,
  deleted_by VARCHAR(25) NOT NULL,
  deleted_date VARCHAR(25) NOT NULL
);

-- delete_union_list
CREATE TABLE IF NOT EXISTS delete_union_list (
  delu_id SERIAL PRIMARY KEY,
  union_id INTEGER NOT NULL,
  union_name VARCHAR(30),
  region VARCHAR(30),
  zone VARCHAR(25) NOT NULL,
  no_of_warehouse VARCHAR(4) NOT NULL,
  no_of_primary_cooperatives VARCHAR(6) NOT NULL,
  deleted_by VARCHAR(25) NOT NULL,
  deleted_date VARCHAR(25) NOT NULL
);

-- deleted_list_destination
CREATE TABLE IF NOT EXISTS deleted_list_destination (
  deldestid SERIAL PRIMARY KEY,
  dest_id INTEGER NOT NULL,
  union_id VARCHAR(30),
  destination VARCHAR(30),
  region VARCHAR(30),
  zone VARCHAR(25) NOT NULL,
  woreda VARCHAR(25) NOT NULL,
  kebele VARCHAR(25) NOT NULL,
  longitude VARCHAR(15),
  latitude VARCHAR(30),
  altitude VARCHAR(8),
  deleted_by VARCHAR(25) NOT NULL,
  deleted_date VARCHAR(25) NOT NULL
);

-- deleted_regions
CREATE TABLE IF NOT EXISTS deleted_regions (
  did SERIAL PRIMARY KEY,
  region_id INTEGER NOT NULL,
  region_name_e VARCHAR(60) NOT NULL,
  region_name_a VARCHAR(40) NOT NULL,
  population INTEGER NOT NULL,
  area INTEGER NOT NULL,
  density DECIMAL(10,0) NOT NULL,
  capital VARCHAR(15) NOT NULL,
  map VARCHAR(255) NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_by VARCHAR(30) NOT NULL,
  deleted_date VARCHAR(26) NOT NULL
);

-- deleted_woredas
CREATE TABLE IF NOT EXISTS deleted_woredas (
  delwid SERIAL PRIMARY KEY,
  woreda_id INTEGER NOT NULL,
  woreda_name VARCHAR(190) NOT NULL,
  seat VARCHAR(100) NOT NULL,
  region_id INTEGER NOT NULL,
  zone_id INTEGER NOT NULL,
  remarks TEXT NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_by VARCHAR(25) NOT NULL,
  deleted_date VARCHAR(26) NOT NULL
);

-- deleted_zones
CREATE TABLE IF NOT EXISTS deleted_zones (
  dzoneid SERIAL PRIMARY KEY,
  zone_id INTEGER NOT NULL,
  zone_name VARCHAR(255) NOT NULL,
  seat VARCHAR(255) NOT NULL,
  region_id INTEGER NOT NULL,
  map VARCHAR(255) NOT NULL,
  rectime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_by VARCHAR(25) NOT NULL,
  deleted_date VARCHAR(20) NOT NULL
);

-- department
CREATE TABLE IF NOT EXISTS department (
  depid SERIAL PRIMARY KEY,
  department VARCHAR(40) NOT NULL
);

-- distribution_channel
CREATE TABLE IF NOT EXISTS distribution_channel (
  id SERIAL PRIMARY KEY,
  channel_name VARCHAR(50) NOT NULL,
  location VARCHAR(60) NOT NULL,
  contact_person VARCHAR(60) NOT NULL,
  contact_number VARCHAR(25) NOT NULL,
  email VARCHAR(50) NOT NULL
);

-- eabc_cwh
CREATE TABLE IF NOT EXISTS eabc_cwh (
  eaid SERIAL PRIMARY KEY,
  center VARCHAR(50) NOT NULL,
  destination VARCHAR(50) NOT NULL,
  region VARCHAR(30) NOT NULL,
  zone VARCHAR(30) NOT NULL,
  woreda VARCHAR(30) NOT NULL,
  town VARCHAR(50) NOT NULL,
  year_established VARCHAR(30) NOT NULL,
  own_cwh VARCHAR(6) NOT NULL,
  rental_cwh VARCHAR(10) NOT NULL,
  carrying_capacity VARCHAR(30) NOT NULL,
  cwh_storeman_name VARCHAR(50) NOT NULL,
  sex VARCHAR(10) NOT NULL,
  level_of_education VARCHAR(20) NOT NULL,
  mobile VARCHAR(15) NOT NULL,
  office_availability VARCHAR(5) NOT NULL,
  computer_aval VARCHAR(5) NOT NULL,
  smartphone VARCHAR(5) NOT NULL,
  wifi VARCHAR(5) NOT NULL,
  electric VARCHAR(5) NOT NULL,
  netword VARCHAR(5) NOT NULL
);

-- eligibility_criteria
CREATE TABLE IF NOT EXISTS eligibility_criteria (
  criteria_id SERIAL PRIMARY KEY,
  criteria_title VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(20) DEFAULT 'Other'
    CHECK (category IN ('Financial','Technical','Legal','Experience','Other')),
  weight DECIMAL(5,2) DEFAULT 0.00,
  status VARCHAR(10) DEFAULT 'Active'
    CHECK (status IN ('Active','Inactive')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- epy_fertilizer_subsidy
CREATE TABLE IF NOT EXISTS epy_fertilizer_subsidy (
  eid SERIAL PRIMARY KEY,
  year VARCHAR(8),
  region INTEGER NOT NULL,
  fert_type VARCHAR(30) NOT NULL,
  amt_mt VARCHAR(20) NOT NULL,
  amt_qt VARCHAR(20) NOT NULL,
  price_before_subside VARCHAR(20) NOT NULL,
  price_after_subsidy VARCHAR(20) NOT NULL,
  updated_date VARCHAR(18) NOT NULL,
  update_by VARCHAR(20) NOT NULL
);

-- etho_regions
CREATE TABLE IF NOT EXISTS etho_regions (
  erid SERIAL PRIMARY KEY,
  country VARCHAR(50),
  region VARCHAR(40),
  zone VARCHAR(30) NOT NULL,
  woreda VARCHAR(30) NOT NULL
);

-- fert_autocalc_farm
CREATE TABLE IF NOT EXISTS fert_autocalc_farm (
  figid SERIAL PRIMARY KEY,
  region INTEGER DEFAULT 0,
  zone INTEGER DEFAULT 0,
  woreda INTEGER DEFAULT 0,
  kebele VARCHAR(40),
  year_season VARCHAR(50),
  farmer_id INTEGER DEFAULT 0,
  crop VARCHAR(20),
  land_allocated VARCHAR(20),
  urea_required VARCHAR(15),
  dap_required VARCHAR(20)
);

-- fert_balance
CREATE TABLE IF NOT EXISTS fert_balance (
  fbid SERIAL PRIMARY KEY,
  pcid INTEGER NOT NULL,
  year VARCHAR(18) NOT NULL,
  fert_type VARCHAR(20) NOT NULL,
  total_received VARCHAR(20) NOT NULL,
  total_sale_accountant VARCHAR(20) NOT NULL,
  total_sale_stock VARCHAR(25) NOT NULL,
  balance VARCHAR(20) NOT NULL,
  last_update VARCHAR(28) NOT NULL
);

-- fert_balance_destn
CREATE TABLE IF NOT EXISTS fert_balance_destn (
  fbid SERIAL PRIMARY KEY,
  destination INTEGER NOT NULL,
  year VARCHAR(18) NOT NULL,
  fert_type VARCHAR(20) NOT NULL,
  total_received VARCHAR(20) NOT NULL,
  total_sale_accountant VARCHAR(20) NOT NULL,
  total_sale_stock VARCHAR(25) NOT NULL,
  balance VARCHAR(20) NOT NULL,
  last_update VARCHAR(28) NOT NULL
);

-- fert_demand
CREATE TABLE IF NOT EXISTS fert_demand (
  fert_id SERIAL PRIMARY KEY,
  year VARCHAR(8) NOT NULL,
  region INTEGER NOT NULL,
  zone INTEGER NOT NULL,
  union_id INTEGER NOT NULL,
  destination INTEGER NOT NULL,
  fert_type VARCHAR(15) NOT NULL,
  lot_no INTEGER NOT NULL,
  amount VARCHAR(15) NOT NULL
);

-- fert_demand_allocation
CREATE TABLE IF NOT EXISTS fert_demand_allocation (
  fal_id SERIAL PRIMARY KEY,
  year VARCHAR(12) NOT NULL, 
  union_id INTEGER NOT NULL,
  destination INTEGER NOT NULL,
  fert_type VARCHAR(20) NOT NULL,
  lot_no VARCHAR(5) NOT NULL,
  pcid INTEGER NOT NULL,
  allocated VARCHAR(13) NOT NULL,
  assigned_by VARCHAR(100) NOT NULL,
  assigned_date VARCHAR(30) NOT NULL,
  approval BOOLEAN NOT NULL
);
-- fertilizer_requirement_calc
CREATE TABLE IF NOT EXISTS fertilizer_requirement_calc (
  calc_id SERIAL PRIMARY KEY,
  region VARCHAR(50) NOT NULL,
  zone VARCHAR(50) NOT NULL,
  woreda VARCHAR(50) NOT NULL,
  kebele VARCHAR(50) NOT NULL,
  farmer_id VARCHAR(50) NOT NULL,
  farmer_name VARCHAR(150),
  crop VARCHAR(50) NOT NULL,
  crop_category INTEGER,
  total_farm_area_ha DECIMAL(8,2),
  allocated_area_ha DECIMAL(8,2),
  potential_level VARCHAR(10) NOT NULL
    CHECK (potential_level IN ('high','medium','low')),
  urea_rate_kg_ha DECIMAL(8,2),
  dap_rate_kg_ha DECIMAL(8,2),
  urea_required_kg DECIMAL(10,2),
  dap_required_kg DECIMAL(10,2),
  demand_year VARCHAR(10),
  season VARCHAR(20),
  calculated_by VARCHAR(50),
  calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CREATE INDEX idx_frc_region ON fertilizer_requirement_calc(region);
-- CREATE INDEX idx_frc_zone ON fertilizer_requirement_calc(zone);
-- CREATE INDEX idx_frc_woreda ON fertilizer_requirement_calc(woreda);
-- CREATE INDEX idx_frc_kebele ON fertilizer_requirement_calc(kebele);
-- CREATE INDEX idx_frc_farmer_id ON fertilizer_requirement_calc(farmer_id);
-- CREATE INDEX idx_frc_crop ON fertilizer_requirement_calc(crop);
 
-- fertilizer_sold
CREATE TABLE IF NOT EXISTS fertilizer_sold (
  fsid SERIAL PRIMARY KEY,
  transaction_code VARCHAR(25),
  pcid VARCHAR(10),
  year VARCHAR(8),
  fert_type VARCHAR(20),
  farmer_name VARCHAR(25),
  f_father_name VARCHAR(25),
  f_gf_name VARCHAR(25),
  mobile VARCHAR(10),
  sex VARCHAR(6),
  farm_area_ha VARCHAR(10),
  fert_type_sold VARCHAR(20),
  fert_amount_DAP VARCHAR(10),
  fert_amount_UREA VARCHAR(10),
  fert_amount_total VARCHAR(15),
  total_payment VARCHAR(15),
  sold_by VARCHAR(30),
  sold_date VARCHAR(30),
  payment_status VARCHAR(2),
  bank_transaction_id VARCHAR(35),
  store_approval VARCHAR(2),
  withdraw_date VARCHAR(30),
  far_approval VARCHAR(2),
  store_person VARCHAR(25),
  time_transaction_closed VARCHAR(28)
);
 
-- fertilizer_specifications
CREATE TABLE IF NOT EXISTS fertilizer_specifications (
  spec_id SERIAL PRIMARY KEY,
  fert_id INTEGER NOT NULL,
  nutrient_content VARCHAR(255),
  nitrogen_percent DECIMAL(5,2),
  phosphorus_percent DECIMAL(5,2),
  potassium_percent DECIMAL(5,2),
  sulfur_percent DECIMAL(5,2),
  moisture_percent DECIMAL(5,2),
  granule_size VARCHAR(100),
  color VARCHAR(50),
  appearance VARCHAR(100),
  packaging VARCHAR(100),
  remarks TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
 
-- fertilizer_transactions
CREATE TABLE IF NOT EXISTS fertilizer_transactions (
  id INTEGER,
  waybill_no VARCHAR(30) NOT NULL,
  truck_assign_id INTEGER NOT NULL,
  transaction_type VARCHAR(30) NOT NULL,
  date VARCHAR(25) NOT NULL,
  batch INTEGER NOT NULL,
  fertilizer_type VARCHAR(100) NOT NULL,
  amount_on_the_document VARCHAR(20) NOT NULL,
  quantity VARCHAR(20) NOT NULL,
  from_location VARCHAR(60) NOT NULL,
  to_location VARCHAR(60) NOT NULL,
  transporter VARCHAR(50) NOT NULL,
  plate_number VARCHAR(15) NOT NULL,
  driver_name VARCHAR(60) NOT NULL,
  receiver_name VARCHAR(60) NOT NULL,
  driver_agreement INTEGER NOT NULL,
  datetime_driver VARCHAR(28) NOT NULL,
  receiver_acceptance INTEGER NOT NULL,
  datetime_receiver VARCHAR(28) NOT NULL,
  note TEXT NOT NULL,
  approval INTEGER NOT NULL,
  approval_by VARCHAR(60) NOT NULL,
  approved_datetime VARCHAR(28) NOT NULL
);


-- fertilizer_type
CREATE TABLE IF NOT EXISTS fertilizer_type (
  id SERIAL PRIMARY KEY,
  fertilizer_type VARCHAR(100) NOT NULL,
  type_all_name VARCHAR(200) NOT NULL,
  note TEXT NOT NULL,
  used INTEGER NOT NULL,
  picture VARCHAR(255) NOT NULL
);
 
-- fertilizer_types
CREATE TABLE IF NOT EXISTS fertilizer_types (
  fert_id SERIAL PRIMARY KEY,
  fert_name VARCHAR(100) NOT NULL,
  fert_source VARCHAR(100),
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
 
-- job_position
CREATE TABLE IF NOT EXISTS job_position (
  id SERIAL PRIMARY KEY,
  dep INTEGER NOT NULL,
  job_position_name VARCHAR(100) NOT NULL,
  organization_name VARCHAR(80) NOT NULL
);
 
-- kebele
CREATE TABLE IF NOT EXISTS kebele (
  kebele_id SERIAL PRIMARY KEY,
  kebele_name VARCHAR(150) NOT NULL,
  region VARCHAR(100) NOT NULL,
  zone VARCHAR(100) NOT NULL,
  woreda_id VARCHAR(100) NOT NULL
);
 
-- kebele_fert_demand_summary
CREATE TABLE IF NOT EXISTS kebele_fert_demand_summary (
  kfdid SERIAL PRIMARY KEY,
  kebele VARCHAR(50) NOT NULL,
  woreda INTEGER NOT NULL,
  zone INTEGER NOT NULL,
  region INTEGER NOT NULL,
  year_season VARCHAR(30) NOT NULL,
  fert_type VARCHAR(25) NOT NULL,
  demand_collected VARCHAR(20) NOT NULL,
  demand_intellegence VARCHAR(20) NOT NULL,
  demand_adjusted_by_kebele VARCHAR(20) NOT NULL,
  demand_adjusted_by_woreda VARCHAR(20) NOT NULL,
  stop_adjustment INTEGER NOT NULL
);
 
-- language
CREATE TABLE IF NOT EXISTS language (
  lid SERIAL PRIMARY KEY,
  language VARCHAR(1) NOT NULL
);
 
-- list_destination
CREATE TABLE IF NOT EXISTS list_destination (
  dest_id SERIAL PRIMARY KEY,
  union_id VARCHAR(30),
  destination VARCHAR(30),
  region VARCHAR(30),
  zone VARCHAR(25) NOT NULL,
  woreda VARCHAR(25) NOT NULL,
  kebele VARCHAR(25) NOT NULL,
  longitude VARCHAR(15),
  latitude VARCHAR(30),
  altitude VARCHAR(8)
);
 
-- list_destination_members
CREATE TABLE IF NOT EXISTS list_destination_members (
  id SERIAL PRIMARY KEY,
  fullname VARCHAR(80) NOT NULL,
  destid VARCHAR(10) NOT NULL,
  union_id VARCHAR(10) NOT NULL,
  region VARCHAR(20) NOT NULL,
  zone VARCHAR(20) NOT NULL,
  address VARCHAR(255) NOT NULL,
  mobile VARCHAR(12) NOT NULL,
  email VARCHAR(90) NOT NULL,
  position VARCHAR(30) NOT NULL,
  id_card VARCHAR(255) NOT NULL,
  picture VARCHAR(255) NOT NULL,
  signature VARCHAR(255) NOT NULL
);
 
-- list_destination_old
CREATE TABLE IF NOT EXISTS list_destination_old (
  dest_id SERIAL PRIMARY KEY,
  union_id VARCHAR(30),
  destination VARCHAR(30),
  region VARCHAR(30),
  zone VARCHAR(25) NOT NULL,
  woreda VARCHAR(25) NOT NULL,
  kebele VARCHAR(25) NOT NULL,
  longitude VARCHAR(15),
  latitude VARCHAR(30),
  altitude VARCHAR(8)
);
 
-- list_investors_members
CREATE TABLE IF NOT EXISTS list_investors_members (
  id INTEGER,
  company_name VARCHAR(10) NOT NULL,
  fullname VARCHAR(80) NOT NULL,
  region VARCHAR(20) NOT NULL,
  zone VARCHAR(20) NOT NULL,
  woreda VARCHAR(10) NOT NULL,
  kebele VARCHAR(10) NOT NULL,
  address VARCHAR(255) NOT NULL,
  mobile VARCHAR(12) NOT NULL,
  email VARCHAR(80) NOT NULL,
  position VARCHAR(30) NOT NULL,
  branch_name VARCHAR(50) NOT NULL,
  id_no VARCHAR(12) NOT NULL,
  picture VARCHAR(255) NOT NULL
);
  
-- shmagle
CREATE TABLE IF NOT EXISTS  shmagle (
  id SERIAL PRIMARY KEY,
  "union" VARCHAR(32) NOT NULL,
  region VARCHAR(60) NOT NULL,
  zone VARCHAR(50) NOT NULL,
  woreda VARCHAR(60) NOT NULL,
  kebele VARCHAR(60) NOT NULL,
  latitude NUMERIC(10,6),
  longitude NUMERIC(10,6),
  altitude NUMERIC(10,2)
);  

-- staff_organization_list 
CREATE TABLE IF NOT EXISTS staff_organization_list (
  st_org_id SERIAL PRIMARY KEY,
  organization_name VARCHAR(175) NOT NULL,
  staff_fullname VARCHAR(60) NOT NULL,
  position VARCHAR(60) NOT NULL,
  id_no VARCHAR(15) NOT NULL,
  mobile VARCHAR(14) NOT NULL,
  email VARCHAR(70) NOT NULL,
  photo VARCHAR(255) NOT NULL,
  signature VARCHAR(255) NOT NULL
);


-- supad_login
CREATE TABLE IF NOT EXISTS supad_login (
  lgid SERIAL PRIMARY KEY,
  date TIMESTAMP,
  otp VARCHAR(5),
  username VARCHAR(15)
);


-- super_admin
CREATE TABLE IF NOT EXISTS super_admin (
  said SERIAL PRIMARY KEY,
  fullname VARCHAR(50) NOT NULL,
  email VARCHAR(80) NOT NULL,
  password VARCHAR(255) NOT NULL,
  recdate TIMESTAMP
);


-- system_feedback_collection
CREATE TABLE IF NOT EXISTS system_feedback_collection (
  sfid SERIAL PRIMARY KEY,
  email VARCHAR(100),
  which_system VARCHAR(150),
  comment TEXT,
  criticality VARCHAR(8) NOT NULL,
  regtime TIMESTAMP
);


-- tbl_requisition_commercial
CREATE TABLE IF NOT EXISTS tbl_requisition_commercial (
  req_id INTEGER PRIMARY KEY,
  farm_name VARCHAR(50) NOT NULL,
  investor_name VARCHAR(50) NOT NULL,
  region VARCHAR(30) NOT NULL,
  season VARCHAR(20) NOT NULL,
  type_of_crop_sown TEXT NOT NULL,
  req_fert_type VARCHAR(50) NOT NULL,
  req_fert_qty NUMERIC(10,2),
  date_requested DATE NOT NULL,
  remark TEXT
);


-- tender_budget_confirmations
CREATE TABLE IF NOT EXISTS tender_budget_confirmations (
  confirmation_id SERIAL PRIMARY KEY,
  tender_id INTEGER NOT NULL,
  approved_budget NUMERIC(18,2) NOT NULL,
  approval_date DATE NOT NULL,
  budget_letter VARCHAR(255),
  remarks TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- tenders
-- CREATE TYPE  tender_status AS ENUM ('Draft','Open','Closed','Awarded','Cancelled');
CREATE TABLE IF NOT EXISTS  tenders (
  tender_id SERIAL PRIMARY KEY,
  tender_ref VARCHAR(100) UNIQUE NOT NULL,
  fiscal_year VARCHAR(10) NOT NULL,
  fert_type VARCHAR(100) NOT NULL,
  region VARCHAR(100) NOT NULL,
  total_est_budget NUMERIC(18,2) DEFAULT 0.00,
  tender_title VARCHAR(255),
  issue_date TIMESTAMP,
  closing_date TIMESTAMP,
  status tender_status DEFAULT 'Draft',
  tender_file VARCHAR(255),
  created_by INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  procurement_method VARCHAR(100),
  published BOOLEAN DEFAULT FALSE,
  publish_date TIMESTAMP,
  document_price NUMERIC(10,2) DEFAULT 2000
);


-- truck_assignment
CREATE TABLE IF NOT EXISTS truck_assignment (
  tas_id SERIAL PRIMARY KEY,
  transporter_name VARCHAR(60) NOT NULL,
  truck_plate_no VARCHAR(12) NOT NULL,
  driver VARCHAR(40) NOT NULL,
  region VARCHAR(25) NOT NULL,
  union_name VARCHAR(20) NOT NULL,
  destination VARCHAR(20) NOT NULL,
  date_assignment TIMESTAMP,
  status INTEGER NOT NULL
);


-- truck_model
CREATE TABLE IF NOT EXISTS truck_model (
  tmid SERIAL PRIMARY KEY,
  model_name VARCHAR(25) NOT NULL
);


-- truck_tracking
CREATE TABLE IF NOT EXISTS truck_tracking (
  ttid SERIAL PRIMARY KEY,
  truck_plate_no VARCHAR(10) NOT NULL,
  driver VARCHAR(50) NOT NULL,
  checkpoint VARCHAR(20) NOT NULL,
  destination VARCHAR(80) NOT NULL,
  arrived_at TIMESTAMP,
  dispatched_at TIMESTAMP,
  datetime TIMESTAMP,
  status INTEGER NOT NULL,
  note TEXT
);


-- truck_type
CREATE TABLE IF NOT EXISTS truck_type (
  ttid SERIAL PRIMARY KEY,
  truck_type VARCHAR(25) NOT NULL
);


-- union_list
CREATE TABLE IF NOT EXISTS union_list (
  union_id SERIAL PRIMARY KEY,
  union_name VARCHAR(50),
  region VARCHAR(30),
  zone VARCHAR(25) NOT NULL,
  no_of_warehouse INTEGER,
  no_of_primary_cooperatives INTEGER
);


-- unit_of_measure
CREATE TABLE IF NOT EXISTS unit_of_measure (
  id SERIAL PRIMARY KEY,
  unit VARCHAR(100) NOT NULL
);


-- user_login
CREATE TABLE IF NOT EXISTS user_login (
  user_id SERIAL PRIMARY KEY,
  -- mobile VARCHAR(12) NOT NULL,
  user_email VARCHAR(255) NOT NULL UNIQUE,
  profile_img VARCHAR(255),
  last_seen TIMESTAMP,
  created_at TIMESTAMP DEFAULT now(),
  is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  verification_token VARCHAR(128),
  verification_token_expires TIMESTAMP,
  signature VARCHAR(255)  
); 
 
-- User info table
CREATE TABLE IF NOT EXISTS user_info (
    user_info_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES user_login(user_id),
    user_full_name VARCHAR(255) NOT NULL,
    user_phone VARCHAR(255) NOT NULL
);

-- User password table
CREATE TABLE IF NOT EXISTS user_pass (
    user_pass_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES user_login(user_id),
    user_password_hashed VARCHAR(255) NOT NULL
);

-- Password reset tokens table
CREATE TABLE IF NOT EXISTS password_reset_tokens (
    token_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES user_login(user_id),
    reset_token VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP NOT NULL
);

-- User roles table
CREATE TABLE IF NOT EXISTS user_role (
    user_role_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES user_login(user_id),
    role_name INT NOT NULL
);



-- users_customers
CREATE TABLE IF NOT EXISTS users_customers (
  ucid SERIAL PRIMARY KEY,
  company VARCHAR(100),
  fullname VARCHAR(50),
  mobile VARCHAR(15),
  email VARCHAR(80),
  position VARCHAR(50),
  password VARCHAR(255),
  photo VARCHAR(255) NOT NULL,
  approval INTEGER DEFAULT 0
);


-- warehouse_fert_count
CREATE TABLE IF NOT EXISTS warehouse_fert_count (
  whfc_id INTEGER PRIMARY KEY,
  warehouse_name VARCHAR(200) NOT NULL,
  car_plate_no VARCHAR(15) NOT NULL,
  capacity INTEGER,
  start_number INTEGER,
  end_number INTEGER,
  counting_number INTEGER NOT NULL,
  dateTime TIMESTAMP,
  recorded_by VARCHAR(30) NOT NULL
);


-- woreda_fert_demand_summary
CREATE TABLE IF NOT EXISTS woreda_fert_demand_summary (
  wfdid SERIAL PRIMARY KEY,
  woreda INTEGER NOT NULL,
  zone INTEGER NOT NULL,
  region INTEGER NOT NULL,
  year_season VARCHAR(30) NOT NULL,
  fert_type VARCHAR(25) NOT NULL,
  demand_collected NUMERIC(12,2),
  demand_intellegence NUMERIC(12,2),
  demand_adjusted_by_kebele NUMERIC(12,2),
  demand_adjusted_by_woreda NUMERIC(12,2),
  demand_adjusted_by_zone NUMERIC(12,2),
  stop_adjustment INTEGER NOT NULL
);


-- zones
CREATE TABLE IF NOT EXISTS zones (
  zone_id SERIAL PRIMARY KEY,
  zone_name VARCHAR(255) NOT NULL,
  seat VARCHAR(255) NOT NULL,
  region_id INTEGER NOT NULL,
  map VARCHAR(255),
  recTime TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tets(
  id serial primary key
);

 

