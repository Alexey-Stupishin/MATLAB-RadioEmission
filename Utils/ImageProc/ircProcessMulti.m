function [data, curr] = ircProcessMulti(rd3, curr, par, par2, pcom)

S_SEARCH = 1;
S_BACK = 2;
S_FORWARD = 3;

N = size(rd3, 3);

from = [];
to = [];
data = [];
stored = [];
state = S_SEARCH;
while true
    switch state
        case S_SEARCH
            if curr > N
                break;
            end
            jets = ircProcess(rd3(:, :, curr), par);
            if ~isempty(jets)
                stored = [stored l_createData(jets, curr)];
                state = S_BACK;
                seed = curr;
                from = seed;
                to = seed;
                disp(['c=' num2str(curr), ' search'])
            else
                disp(['c=' num2str(curr), ' empty'])
                curr = curr + 1;
            end
            
        case S_BACK
            curr = curr - 1;
            stopback = true;
            if curr >= 1
                jets = ircProcess(rd3(:, :, curr), par2);
                if ~isempty(jets)
                    stored = [l_createData(jets, curr) stored];
                    from = curr;
                    stopback = false; % continue back
                    disp(['c=' num2str(curr), ' back'])
                end
            end
            if  stopback
                curr = seed;
                state = S_FORWARD;
            end
            
        case S_FORWARD
            curr = curr + 1;
            stopforw = true;
            if curr <= N
                jets = ircProcess(rd3(:, :, curr), par2);
                if ~isempty(jets)
                    stored = [stored l_createData(jets, curr)];
                    to = curr;
                    stopforw = false; % continue forward
                    disp(['c=' num2str(curr), ' for'])
                end
            end
            if stopforw
                % from-to process
                if to - from >= pcom.cadences
                    data.stored = stored;
                end
                return
            end
    end
end

end

%--------------------------------------------------------------------------
function data = l_createData(jets, pos)
    data = struct('jets', jets, 'pos', pos);
end


% l_process(stored, pcomp);
% %--------------------------------------------------------------------------
% function same = l_compareJets(jc, js, pcomp)
% 
% cross = jc.image & js.image;
% cardcross = numel(cross(cross));
% same = cardcross/max(jc.cardinality, js.cardinality) > pcomp.commonpart;
% 
% end
% 
% %--------------------------------------------------------------------------
% function l_compare(jc, js, pcomp)
% 
% c = [];
% for k1 = 1:length(jc)
%     for k2 = 1:length(js)
%         c = l_compareJets(jc(k1), js(k2), pcomp);
%     end
% end
% 
% if all(c == 0)
% else
%     
% end
% 
% end
% 
% %--------------------------------------------------------------------------
% function l_process(stored, pcomp)
% 
% jcomb = stored(1);
% for k = 1:length(stored)
%     l_compare(jcomb, stored(k), pcomp);
% end
% 
% end
