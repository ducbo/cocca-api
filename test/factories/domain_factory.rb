FactoryGirl.define do
  factory :audit_domain, class: Audit::Domain do
    audit_transaction
    audit_operation 'I'
    roid '5-CoCCA'
    name 'domains.ph'
    exdate '2016-02-17 3:00 PM'.to_time
    clid 'alpha'
    crid 'alph'
    createdate '2015-02-17 3:00 PM'.to_time
    zone 'ph'
    registrant 'registrant'
    authinfopw 'ABC123'
  end

  factory :audit_domain_event, class: Audit::DomainEvent do
    audit_transaction
    audit_operation 'I'
    sequence(:id, 1) { |id| id}
    domain_roid '5-CoCCA'
    domain_name @domain
    client_clid 'alpha'
    event 'REGISTRATION'
    term_length 1
    term_units 'YEAR'
    expiry_date 1.to_i.year.from_now
    ledger_id 1
    login_username 'admin'
  end

  factory :audit_domain_contact, class: Audit::DomainContact do
    audit_transaction
    audit_operation 'I'
    domain_name 'domains.ph'
    contact_id 'domain_admin'
    type 'admin'
  end
end

def create_domain audit_time: Time.now, partner: PARTNER
  audit_transaction = audit_master audit_time, partner: partner
  audit_operation = 'I'

  create  :audit_ledger,
          audit_transaction: audit_transaction,
          audit_operation: audit_operation

  create  :audit_domain,
          audit_transaction: audit_transaction,
          audit_operation: audit_operation,
          createdate: '2015-03-07 17:00'.in_time_zone

  create  :audit_domain_event,
          audit_transaction: audit_transaction,
          audit_operation: audit_operation,
          expiry_date: '2017-03-07 17:00'.in_time_zone
end

def update_domain audit_time: Time.now
  audit_transaction = audit_master audit_time

  create :audit_domain, audit_transaction: audit_transaction, audit_operation: 'U'

  create  :audit_domain_event,
          audit_transaction: audit_transaction,
          audit_operation: 'I',
          expiry_date: '2017-03-07 17:00'.in_time_zone,
          event: 'MODIFICATION'
end

def update_domain_contact audit_time: Time.now
  create :audit_domain_contact, audit_transaction: audit_master(audit_time)
end

def renew_domain audit_time: '2015-03-13 07:49 AM'.in_time_zone
  audit_transaction = audit_master audit_time

  create  :audit_ledger,
          audit_transaction: audit_transaction,
          audit_operation: 'I'

  create  :audit_domain,
          audit_transaction: audit_transaction,
          audit_operation: 'U',
          createdate: '2015-03-13 07:35 AM'.in_time_zone

  create  :audit_domain_event,
          audit_transaction: audit_transaction,
          audit_operation: 'I',
          event: 'RENEWAL',
          term_length: 3,
          expiry_date: '2019-03-13 07:35 AM'.in_time_zone

end
