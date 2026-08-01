G := PSL(2,11);;
if Size(G) <> 660 then
  Error("wrong PSL(2,11) order");
fi;
if not IsSimpleGroup(G) then
  Error("PSL(2,11) was not certified simple");
fi;
Print("PSL211_ORDER_660_SIMPLE_OK\n");
QUIT_GAP(0);
