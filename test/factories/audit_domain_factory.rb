FactoryGirl.define do
  factory :audit_domain, class: Audit::Domain do
    audit_transaction
    audit_operation 'I'
    roid '5-CoCCA'
    name 'domains.ph'
    exdate '2016-02-17 3:00 PM'.to_time
    clid 'alpha'
    crid 'alpha'
    createdate '2015-02-17 3:00 PM'.to_time
    zone 'ph'
    registrant 'registrant'
    authinfopw 'ABC123'

    factory :transfer_domain_request, class: Audit::Domain do
      audit_operation 'U'
      st_pendingtransfer  'Requested'
    end

    factory :register_domain, class: Audit::Domain do
      createdate '2015-03-07 5:00 PM'.in_time_zone

      after :create do |domain|
        create :audit_master, audit_transaction: domain.audit_transaction,
                              audit_time: domain.createdate

        create  :register_ledger, audit_transaction: domain.audit_transaction,
                                  domain_name: domain.name

        create  :audit_domain_event,  audit_transaction: domain.audit_transaction,
                                      domain_name: domain.name
      end

      factory :register_domain_in_months, class: Audit::Domain do
        after :create do |domain|
          domain.domain_event.update! term_length: 12, term_units: 'MONTHS'
        end
      end
    end

    factory :update_domain, class: Audit::Domain do
      audit_operation 'U'

      after :create do |domain|
        create :audit_master, audit_transaction: domain.audit_transaction,
                              audit_time: domain.createdate
      end

      factory :transfer_domain, class: Audit::Domain do
        clid 'beta'
        createdate '2015-12-15 3:30 PM'.in_time_zone

        after :create do |domain|
          create  :transfer_ledger, audit_transaction: domain.audit_transaction,
                                    domain_name: domain.name
        end
      end

      factory :renew_domain, class: Audit::Domain do
        createdate '2015-03-13 07:35 AM'.in_time_zone

        after :create do |domain|
          create  :renew_ledger,  audit_transaction: domain.audit_transaction,
                                  domain_name:  domain.name

          create  :renew_domain_event,  audit_transaction: domain.audit_transaction,
                                        term_length: 3,
                                        expiry_date: domain.createdate + 3.years,
                                        domain_name: domain.name
        end

        factory :renew_domain_in_months, class: Audit::Domain do
          after :create do |domain|
            domain.domain_event.update! term_length: 36, term_units: 'MONTHS'
          end
        end
      end
    end
  end
end

def create_domain audit_transaction: nil, audit_time: Time.now, partner: PARTNER
  audit_transaction ||= audit_master(audit_time, partner: partner)
  audit_operation = 'I'

  create  :audit_ledger,
          audit_transaction: audit_transaction,
          audit_operation: audit_operation

  domain = create :audit_domain,
                  audit_transaction: audit_transaction,
                  audit_operation: audit_operation,
                  createdate: '2015-03-07 17:00'.in_time_zone

  create  :audit_domain_event,
          audit_transaction: audit_transaction,
          audit_operation: audit_operation,
          expiry_date: '2017-03-07 17:00'.in_time_zone,
          domain_name:  domain.name

  domain
end

def update_domain audit_time: Time.now, partner: PARTNER
  audit_transaction = audit_master audit_time, partner: partner

  create :audit_domain, audit_transaction: audit_transaction, audit_operation: 'U'
end

def update_domain_contact audit_time: Time.now, partner: PARTNER
  create :audit_domain_contact, audit_transaction: audit_master(audit_time, partner: partner)
end

def renew_domain audit_time: '2015-03-13 07:49 AM', partner: PARTNER
  audit_transaction = audit_master audit_time, partner: partner

  create  :audit_ledger,
          audit_transaction: audit_transaction,
          audit_operation: 'I'

  domain = create :audit_domain,
                  audit_transaction: audit_transaction,
                  audit_operation: 'U',
                  createdate: '2015-03-13 07:35 AM'.in_time_zone

  create  :audit_domain_event,
          audit_transaction: audit_transaction,
          audit_operation: 'I',
          event: 'RENEWAL',
          term_length: 3,
          expiry_date: '2019-03-13 07:35 AM'.in_time_zone,
          domain_name: domain.name

  domain
end

def register_domain audit_transaction: nil
    create_domain audit_transaction: audit_transaction
end

def transfer_domain_request
  create :transfer_domain_request, audit_transaction: audit_master(Time.now)
end

def register_domain_with_period_in_months
  audit_transaction = audit_master Time.now
  audit_operation   = 'I'

  create  :audit_ledger,
          audit_transaction: audit_transaction,
          audit_operation: audit_operation

  domain = create :audit_domain,
                  audit_transaction: audit_transaction,
                  audit_operation: audit_operation,
                  createdate: '2015-03-07 17:00'.in_time_zone

  create  :audit_domain_event,
          audit_transaction: audit_transaction,
          audit_operation: audit_operation,
          expiry_date: '2017-03-07 17:00'.in_time_zone,
          domain_name:  domain.name,
          term_length:  12,
          term_units: 'MONTH'

  domain
end

def renew_domain_with_period_in_months
  audit_transaction = audit_master '2015-03-13 7:49 AM'.in_time_zone

  create  :audit_ledger,
          audit_transaction: audit_transaction,
          audit_operation: 'I'

  domain = create :audit_domain,
                  audit_transaction: audit_transaction,
                  audit_operation: 'U',
                  createdate: '2015-07-06 11:30 AM'.in_time_zone

  create  :audit_domain_event,
          audit_transaction: audit_transaction,
          audit_operation: 'I',
          event: 'RENEWAL',
          term_length: 36,
          term_units: 'MONTH',
          expiry_date: '2018-07-06 11:00 AM'.in_time_zone,
          domain_name: domain.name

  domain
end