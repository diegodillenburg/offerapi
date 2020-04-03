class DateValidator < ActiveModel::Validator
  def validate(record)
    return unless record.starts_at && record.ends_at

    record.errors[:ends_at] << 'End date needs to be posterior to starting date' if record.ends_at < record.starts_at
  end
end
