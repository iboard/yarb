# -*- encoding : utf-8 -*-
#
# Secret Hash
# MAKE SURE THIS FILE IS NOT IN YOUR REPOSITORY!!!!
module Secrets

  def self.secret
    {
      smtp: {},
      omniauth: {
        twitter: {
          key:    "1234545",
          secret: "whatisthesecretwordfortoday?"
        },
      }
    }
  end

end
