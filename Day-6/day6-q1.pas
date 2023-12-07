program BoatRace;

var
  totalTime, recordDistance, ways, i, j, speed, remainingTime, distance, product: LongInt;

begin
  product := 1;

  // Assuming four races, you will need to loop over each race's details
  for i := 1 to 4 do
  begin
    readln(totalTime, recordDistance); // Read race details
    ways := 0;

    for j := 0 to totalTime do
    begin
      speed := j;
      remainingTime := totalTime - j;
      distance := speed * remainingTime;

      if distance > recordDistance then
        inc(ways);
    end;

    // Avoid multiplying by 0
    if ways > 0 then
      product := product * ways
    else
    begin
      product := 0;
      break; // No need to continue if any race has no way to beat the record
    end;
  end;

  writeln('Total ways to beat the records: ', product);
end.