module ListingsHelper
    def line_through_class(yes_or_no)
        if yes_or_no == 'Y' or yes_or_no == true
            ''
        else
            'allowed'
        end
    end

    def yes_no_to_boolean(yes_or_no)
        if yes_or_no == 'Y'
            true
        else
            'N'
        end
    end
end
