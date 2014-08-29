% Uses GenChordSeq to easily generate arpeggios of a certain chord
function [ sig ] = GenArpeggio(base, type, duration, volume)
    if strcmp(type,'maj')
        seq = [base base+4 base+7 base+4];
        sig = GenChordSeq(seq, duration, volume);
    elseif strcmp(type,'min')
        seq = [base base+3 base+7 base+3];
        sig = GenChordSeq(seq, duration, volume);
    elseif strcmp(type,'dim')
        seq = [base base+3 base+6 base+3];
        sig = GenChordSeq(seq, duration, volume);
    end

end

