require 'isbnutil/isbn_groups.rb'

module Isbnutil
  class Isbn
    attr_accessor :source, :isValid, :isIsbn13, :isIsbn10, :group, :publisher, :article, :check, :prefix
    
    def initialize(isbn, args)
      groups = args ? args : IsbnGroups.keys
      _parse(isbn, groups)
    end
    
    def self.parse(isbn, args)
      me = Isbn.new(isbn, args)
      return me.isValid ? me : nil
    end
    
    def asIsbn10
      if isValid
        return [@group, @publisher, @article, _calcCheckDigit([@group, @publisher, @article].join(''))].join('-')
      end
    end
    
    def asIsbn13
      if isValid
        if isIsbn13
          return [@prefix, @group, @publisher, @article, _calcCheckDigit([@prefix, @group, @publisher, @article].join(''))].join('-')
        elsif isIsbn10
          return ["978", @group, @publisher, @article, _calcCheckDigit(["978", @group, @publisher, @article].join(''))].join('-')
        end
      end
    end
    
    private
      def _parse(isbn, groups)
        if (isbn =~ /^\d{9}[\dX]$/) != nil
          @source = isbn
          @isValid = true
          @isIsbn10 = true
          @isIsbn13 = false
          details = _split(isbn, groups)
          @group = details["group"]
          @publisher = details["publisher"]
          @article = details["article"]
          @check = details["check"]
        elsif isbn.length==13 && (isbn =~ /^(\d+)-(\d+)-(\d+)-([\dX])$/) != nil
          @source = isbn
          @isValid = true
          @isIsbn10 = true
          @isIsbn13 = false
          @group = $1
          @publisher = $2
          @article = $3
          @check = $4
        elsif (isbn =~ /^(978|979)(\d{9}[\dX]$)/) != nil
          @source = isbn
          @isValid = true
          @isIsbn10 = false
          @isIsbn13 = true
          @prefix = $1
          details = _split($2, groups)
          @group = details["group"]
          @publisher = details["publisher"]
          @article = details["article"]
          @check = details["check"]
        elsif isbn.length==17 && (isbn =~ /^(978|979)-(\d+)-(\d+)-(\d+)-([\dX])$/) != nil
          @source = isbn
          @isValid = true
          @isIsbn10 = false
          @isIsbn13 = true
          @prefix = $1
          @group = $2
          @publisher = $3
          @article = $4
          @check = $5
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
        
        return {"group" => arr[0], "publisher" => arr[1], "article" => arr[2], "check" => arr[3]}
      end
      
      def _getGroupRecord(isbn, groups)
        groups.each do |group|
          if isbn.match('^' + group + '(.+)')
            return {"group" => group, "record" => groups[group.to_i], "rest" => $1}
          end
        end
      end
      
      def _calcCheckDigit(isbn)
        if (isbn.match(/^\d{9}[\dX]?$/))
          c=0
          (0..8).each do |i|
            c = c + (10 - i) * Integer(isbn[i])
          end
          c = (11 -c % 11) % 11
          return c == 10 ? 'X' : c.to_s
        elsif (isbn.match(/(?:978|979)\d{9}[\dX]?/))
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
