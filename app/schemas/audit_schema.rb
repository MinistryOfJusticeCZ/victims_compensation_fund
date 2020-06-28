class AuditSchema < AzaharaSchema::ModelSchema
  def initialize(scope = nil, *attrs)
    @audited_scope = scope
    super(Audited::Audit, *attrs)
  end

  def base_scope
    @audited_scope || super
  end
end
