function index = getIndexFromAudio(audioTag)

% crop tag
v1 = audioTag(1:60000);

% get envelope from tag
v2 = conv(sqrt(v1.^2),ones(1,40));

% digitize tag
v3 = ((v2>3/4*max(v2))*0.5+(v2>1/4*max(v2))*0.5);

risers = find(diff(v3)>0.2);

first_riser = risers(1);
digits = round(2*v3(first_riser + [1000:4000:40000]))-1;

binstring = '0';
for i=1:length(digits)
    if digits(i)>-0.1
        binstring = [binstring num2str(digits(i))];
    end
end

index = bin2dec(binstring);
end

