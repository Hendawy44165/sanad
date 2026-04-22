export function sendSuccess(res, data, meta, status = 200) {
  return res.status(status).json({
    success: true,
    data,
    ...(meta ? { meta } : {}),
  });
}

export function sendError(res, error, status = 500) {
  return res.status(status).json({
    success: false,
    error,
  });
}
