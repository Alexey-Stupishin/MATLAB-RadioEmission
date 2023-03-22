function ffmpeg(framerate, fullmask, outfile, quiet)

add_parm = '';
if ~exist('quiet', 'var') || quiet
    add_parm = [add_parm  ' -loglevel quiet'];
end

params = ['-y -vf scale="trunc(iw/2)*2:trunc(ih/2)*2" -c:v libx264 -profile:v high -pix_fmt yuv420p' add_parm];

system(['s:\Projects\Matlab\InOut\ffmpeg.exe -framerate ' num2str(framerate) ' -i ' fullmask ' ' params ' ' outfile]);

end
    
