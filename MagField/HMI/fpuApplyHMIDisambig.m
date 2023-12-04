function azim = fpuApplyHMIDisambig(azim, HIMdisamb)

ann = (HIMdisamb == 2 | HIMdisamb == 3 | HIMdisamb == 6 | HIMdisamb == 7);
azim(ann) = azim(ann) + 180;

end
