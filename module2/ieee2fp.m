function x = ieee2fp(ieee)
% calculates the floating-point number from its ieee representation
% input: ieee = 8-character hexidecimal string  or
%               64-bit binary string
%             = (structure) when representation is in scientific notation
%               +- 1.xxxxx... 2^exponent  or
%               +- 0.xxxxx... 2^(-1023)
%             .sign = +1 or -1  as a fp number, not text
%             .exponent = the exponent shown above, must be in [-1023, 1024]
%             .mantissa = 13-character hexidecimal string  or
%                         52-bit binary string
    bin2hex = [(0:9)+'0', (0:5)+'a'];
    if ischar(ieee)
        if length(ieee) == 16
            if any( (ieee < '0' | ieee > 'f') | (ieee > '9' & ieee < 'a') )
                error(['***** hexidecimal string not all 0-9 or a-f: ', ieee])
            end
            x = hex2num(ieee);
        elseif length(ieee) == 64
            if any( ieee < '0' | ieee > '1' )
                error(['***** binary string not all 0-1: ', ieee])
            end
            Ieee = reshape(ieee, 4, 16)';
            Ieee_dec = bin2dec(Ieee);
            ieee_hex = bin2hex(Ieee_dec+1);
            x = hex2num(char(ieee_hex));
        else
            error(['***** string not correct length: ', ieee])
        end
    else
        if ~isstruct(ieee)
            error(['***** input is not a structure variable: ', num2str(ieee)])
        end
        if ieee.sign == +1
            exponent_bin(1) = '0';
        elseif ieee.sign == -1
            exponent_bin(1) = '1';
        else
            error(['***** incorrrect sign: ', num2str(ieee.sign)])
        end
        if mod(ieee.exponent, 1) ~= 0 || ieee.exponent < -(2^10 - 1) || ieee.exponent > 2^10
            error(['***** incorrect exponent: ', ...
                   num2str(ieee.exponent)])
        end
        exponent_bin(2:12) = dec2bin(ieee.exponent+(2^10-1), 11);
        if length(ieee.mantissa) == 52
            if any( ieee.mantissa<'0' | ieee.mantissa>'1' )
                error(['***** binary string not all 0-1: ', ieee])
            end
            x = ieee2fp([exponent_bin, ieee.mantissa]);
        elseif length(ieee.mantissa) == 13
            if any( (ieee.mantissa<'0'|ieee.mantissa>'f') | ...
                    (ieee.mantissa>'9'&ieee.mantissa<'a') )
                error(['***** hexidecimal mantissa not all 0-9 or a-f: ', ...
                       ieee.mantissa])
            end
            Ieee = reshape(exponenet_bin, 4, 3)';
            Ieee_dec = bin2dec(Ieee);
            ieee_hex = bin2hex(Ieee_dec+1);
            x = hex2num([char(ieee_hex), ieee.mantissa]);
        else
            error(['***** incorrect mantissa length: ', num2str(ieee.mantissa)])
        end
    end
end

