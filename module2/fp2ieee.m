function ieee = fp2ieee(x)
% calculates the IEEE representation of a floating-point number in binary
% input: x = floating-point number
% output: ieee.bits = (structure) IEEE representation, i.e., 64 bits of 0's and 1's
%             .split = IEEE representation separated for easier reading
%             .sci = scientific notation:
%                     +- 1.xxxxx... 2^exponent or
%                     +- 0.xxxxx... 2^(-1023)
%             .sign = +1  if x >= 0
%                   = -1  if x < 0
    if ~isfinite(x)
        error('*****  x  is not a finite number')
    end
    x_hex = num2hex(x);
    x_exp_dec = hex2dec(x_hex(1:3));
    ieee.sign = +1;
    x_sign_char = '+';
    x_sign_bin = '0';
    if x_exp_dec >= 2^11
        x_exp_dec = x_exp_dec - 2^11;
        ieee.sign = -1;
        x_sign_char = '-';
        x_sign_bin = '1';
    end
    x_real_exp = x_exp_dec - (2^10 - 1);
    x_mantissa = dec2bin(hex2dec(x_hex(4:16)), 52);
    ieee.bits = [dec2bin(hex2dec(x_hex(1:3)), 12), x_mantissa];
    if x_exp_dec > 0
        ieee.sci = [x_sign_char, '1.', x_mantissa];
    else
        ieee.sci = [x_sign_char, '0.', x_mantissa];
    end
    ieee.sci = [ieee.sci, ' x 2^', num2str(x_real_exp)];
    ieee.split = [x_sign_bin, '|', split(dec2bin(x_exp_dec, 11)), '|', ...
                  split(x_mantissa)];
end
function split_string = split(string)
    if length(string) == 0
        return
    end
    if length(string) <= 4
        split_string = string;
    else
        split_string = [split(string(1:end-4)), ' ', string(end-3: ...
                                                          end)];
    end
end


