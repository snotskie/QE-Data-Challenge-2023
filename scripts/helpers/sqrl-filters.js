const sqrl = require("squirrelly");

// custom filter for formatting dates
// e.g. {{"2022-01-01" | formatDate}}
sqrl.filters.define("formatDate", function(date){
  const then = new Date(date);
  return then.toLocaleDateString("en-US", {"weekday": "short", "month": "short", "day": "numeric", "year": "numeric"});
});

// custom filter for selecting one "column" of an array of objects
// e.g. {{fruits | select("price")}}
sqrl.filters.define("select", function(data, column_name){
  const column = [];
  for (const row of data){
    column.push(row[column_name]);
  }
  
  return column;
});

// custom filter for filtering an array of objects to only those where a "column" is present and truthy
// e.g. {{fruits | is("ripe")}}
sqrl.filters.define("is", function(data, column_name){
  const column = [];
  for (const row of data){
    if (column_name in row && row[column_name]){
      column.push(row);
    }
  }
  
  return column;
});

// custom filter for filtering an array of objects to only those where a "column" is missing or falsey
// e.g. {{fruits | isnt("moldy")}}
sqrl.filters.define("isnt", function(data, column_name){
  const column = [];
  for (const row of data){
    if (!(column_name in row) || !row[column_name]){
      column.push(row);
    }
  }
  
  return column;
});

// custom filter for getting the max of a list
// e.g., {{prices | max}}
sqrl.filters.define("max", function(list){
  const values = list.map(parseFloat).filter(Number.isFinite);
  return Math.max(...values); // ... is the splat syntax
});

// custom filter for getting the min of a list
// e.g., {{prices | min}}
sqrl.filters.define("min", function(list){
  const values = list.map(parseFloat).filter(Number.isFinite);
  return Math.min(...values); // ... is the splat syntax
});

// custom filter for getting the sum of a list
// e.g., {{prices | sum}}
sqrl.filters.define("sum", function(list){
  console.log(list);
  const values = list.map(parseFloat).filter(Number.isFinite);
  if (values.length === 0) return 0;
  if (values.length === 1) return values[0];
  return ExtraMath.sum(...values); // ... is the splat syntax
});

// custom filter for getting the mean of a list
// e.g., {{prices | mean}}
sqrl.filters.define("mean", function(list){
  const values = list.map(parseFloat).filter(Number.isFinite);
  return ExtraMath.mean(...values); // ... is the splat syntax
});

// custom filter for getting the count of a list
// e.g., {{fruit | count}}
sqrl.filters.define("count", function(list){
  return list.length;
});

// custom filter for getting the unique items of a list
// e.g., {{fruit | unique | count}}
sqrl.filters.define("unique", function(list){
  return [...new Set(list)];
});

// custom filter for formatting a list as a bulleted list
// e.g., {{fruit | ul}}
sqrl.filters.define("ul", function(list){
  return "- " + list.join("\n- ");
});

// custom filter for formatting a list as a comma list
// e.g., {{fruit | comma}}
sqrl.filters.define("comma", function(list){
  const copy = [...list]; // ... is the splat syntax
  const last = copy.pop();
  return copy.join(", ") + " and " + last;
});