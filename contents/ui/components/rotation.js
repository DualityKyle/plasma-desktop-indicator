.pragma library

function angleFor(vertical, setting, onLeftEdge) {
  if (!vertical)
    return 0;
  switch (setting) {
    case "edge": return onLeftEdge ? -90 : 90;
    case "90":   return 90;
    case "270":  return 270;
    default:     return 0;
  }
}