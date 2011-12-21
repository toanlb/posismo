# encoding: utf-8
class RewardValidator < ActiveModel::EachValidator
   def validate_each(record, attribute, value)
     result = Reward.where(["reward_type = ? AND starts_at < ? AND promotion_id = ? ", Reward::TYPES.index("キャンペーン報酬"), record[attribute], record[:promotion_id]]).
                     order("starts_at DESC").
                     first
     if result.present?
       record.errors.add(attribute, 'は登録できません') if (result.starts_at < record[attribute]) && (result.ends_at > record[attribute])
     end
   end
end
