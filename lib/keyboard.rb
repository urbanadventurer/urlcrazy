class Keyboard
  def initialize(layout)
    case layout
    when "qwerty" then @rows = ["1234567890-", "qwertyuiop", "asdfghjkl", "zxcvbnm"]
        # france, belgium
    when "azerty" then @rows = ["1234567890-", "azertyuiop", "qsdfghjklm", "wxcvbn"]
        # germany, austria, switzerland, hungary
    when "qwertz" then @rows = ["1234567890-", "qwertzuiop", "asdfghjkl", "yxcvbnm"]
        # dvorak            
    when "dvorak" then @rows = ["1234567890-", "pyfgcrl", "aoeuidhtns", "qjkxbmwvz"]
    else raise("Unknown keyboard: #{layout}")
    end     
  end

  def key_left(char)
    r = row(char)
    return nil if r.nil?
    return nil if r.index(char).nil?
    return nil if r.index(char) == 0  # already far left
    r[r.index(char)-1].nil? ? nil : "%c" % r[r.index(char) - 1]
  end

  def key_right(char)
    r = row(char)
    return nil if r.nil?
    return nil if r.index(char).nil?
    return nil if r.index(char) == r.length - 1  # already far right
    r[r.index(char)+1].nil? ? nil : "%c" % r[r.index(char) + 1]
  end

  def row(char)
    #returns keyboard. eg. qwertyuiop  or nil if not found
    r = @rows.map { |k| k if k.include?(char) }.join
    r.empty? ? nil : r
  end
end
