require 'isbnutil/isbn_groups.rb'

module Isbnutil
  class Isbn
    attr_accessor :source, :isValid, :isIsbn13, :isIsbn10, :group, :imprint, :article, :check, :prefix
    
    def initialize(isbn, args, validateCheckDigit)
      groups = args ? args : IsbnGroups.keys
      _parse(isbn, groups, validateCheckDigit)
    end
    
    def self.parse(isbn, args, validateCheckDigit)
      if validateCheckDigit.nil?
        validateCheckDigit = false
      end
      
      me = Isbn.new(isbn, args, validateCheckDigit)
      return me.isValid ? me : nil
    end
    
    def asIsbn10
      if isValid
        return [@group, @imprint, @article, _calcCheckDigit([@group, @imprint, @article].join(''))].join('-')
      end
    end
    
    def asIsbn13
      if isValid
        if isIsbn13
          return [@prefix, @group, @imprint, @article, _calcCheckDigit([@prefix, @group, @imprint, @article].join(''))].join('-')
        elsif isIsbn10
          return ["978", @group, @imprint, @article, _calcCheckDigit(["978", @group, @imprint, @article].join(''))].join('-')
        end
      end
    end
    
    def self.validate(isbn, validateCheckDigit)
      if validateCheckDigit.nil?
        validateCheckDigit = false
      end
        
      #Cleanup Miscellaneous characters in ISBN
      isbn = isbn.squeeze(' ').gsub(/-/,'').gsub(/\./,'').chomp.upcase
      
      result = "Valid"
      if (isbn.length == 10)
        true if Float(isbn[0..8]) rescue result="Not Numeric"
        if validateCheckDigit
          result = "Invalid Checkdigit" unless isbn[9] == calculateCheckDigit(isbn).to_s
        end
      elsif (isbn.length == 13)
        true if Float(isbn[0..11]) rescue result="Not Numeric"
        if validateCheckDigit
          result = "Invalid Checkdigit" unless isbn[12] == calculateCheckDigit(isbn).to_s
        end
      else
        result = "Invalid Length"
      end
      return result
    end
    
    def self.calculateCheckDigit(isbn)
      if (isbn.match(/^\d{9}[\dX]?$/))
        c=0
        (0..8).each do |i|
          c = c + (10 - i) * Integer(isbn[i])
        end
        c = (11 -c % 11) % 11
        return c == 10 ? 'X' : c.to_s #Returns X in place of 10
      elsif (isbn.match(/(?:978|979|977)\d{9}[\dX]?/))
        c=0
        i=0
        until i > 11
          c = c + Integer(isbn[i]) + 3 * Integer(isbn[i+1])
          i+=2
        end
        c = (10 - c % 10) % 10 #Returns 0 in place of 10
        return c
      end
      return nil
    end
    
    private
      def _parse(isbn, groups, validateCheckDigit)
        @isValid = false
        if (isbn =~ /^\d{9}[\dX]$/) != nil
          @source = isbn
          details = _split(isbn, groups)
          unless details.nil?
            @isValid = true
            @isIsbn10 = true
            @isIsbn13 = false
            @group = details["group"]
            @imprint = details["imprint"]
            @article = details["article"]
            @check = details["check"]
          end
        elsif isbn.length==13 && (isbn =~ /^(\d+)-(\d+)-(\d+)-([\dX])$/) != nil
          @source = isbn
          details = _split(isbn, groups)
          unless details.nil?
            @isValid = true
            @isIsbn10 = true
            @isIsbn13 = false
            @group = $1
            @imprint = $2
            @article = $3
            @check = $4
          end
        elsif (isbn =~ /^(978|979|977)(\d{9}[\dX]$)/) != nil
          @source = isbn
          details = _split($2, groups)
          unless details.nil?
            @isValid = true
            @isIsbn10 = false
            @isIsbn13 = true
            @prefix = $1
            @group = details["group"]
            @imprint = details["imprint"]
            @article = details["article"]
            @check = details["check"]
          end
        elsif isbn.length==17 && (isbn =~ /^(978|979|977)-(\d+)-(\d+)-(\d+)-([\dX])$/) != nil
          @source = isbn
          details = _split(isbn, groups)
          unless details.nil?
            @isValid = true
            @isIsbn10 = false
            @isIsbn13 = true
            @prefix = $1
            @group = $2
            @imprint = $3
            @article = $4
            @check = $5
          end
        end
        
        #Check if Check Digit is correct
        if @isValid && validateCheckDigit
          if @check != _calcCheckDigit([@prefix, @group, @imprint, @article].join('')).to_s
            @isValid = false
          end
        end
        
        return @isValid
      end
      
      def _split(isbn, groups)
        if !isbn.nil?
          if isbn.length == 13
            return _split(isbn[3..isbn.length], groups)
          elsif isbn.length == 10
            return splitToObject(isbn, groups)
          end
        end
      end
      
      def splitToArray(isbn, groups)
        detail = _getGroupRecord(isbn, groups)
        if detail.nil?
          return nil
        end
        IsbnGroups[detail["record"]]["ranges"].each do |range|
          key = detail["rest"][0..range[0].length-1]
          if(range[0] <= key && range[1] >= key)
            rest = detail["rest"][key.length, detail["rest"].length]
            return [detail["group"], key, rest[0..rest.length-2], rest[rest.length-1]]
          end
        end
        
        return nil
      end
      
      def splitToObject(isbn, groups)
        arr = splitToArray(isbn, groups)
        if arr.nil? || arr.length != 4
          return nil
        end
        
        return {"group" => arr[0], "imprint" => arr[1], "article" => arr[2], "check" => arr[3]}
      end
      
      def _getGroupRecord(isbn, groups)
        groups.each do |group|
          if isbn.match('^' + group + '(.+)')
            return {"group" => group, "record" => groups[groups.find_index(group)], "rest" => $1}
          end
        end
        return nil
      end
      
      def _calcCheckDigit(isbn)
        if (isbn.match(/^\d{9}[\dX]?$/))
          c=0
          (0..8).each do |i|
            c = c + (10 - i) * Integer(isbn[i])
          end
          c = (11 -c % 11) % 11
          return c == 10 ? 'X' : c.to_s
        elsif (isbn.match(/(?:978|979|977)\d{9}[\dX]?/))
          c=0
          i=0
          until i > 11
            c = c + Integer(isbn[i]) + 3 * Integer(isbn[i+1])
            i+=2
          end
          c = (10 - c % 10) % 10
          return c
        end
        return nil
      end
  end
end
