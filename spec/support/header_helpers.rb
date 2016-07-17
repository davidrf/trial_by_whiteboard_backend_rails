module HeaderHelpers
  def accept_header(mime_symbol)
    { "Accept" => Mime[mime_symbol].to_s }
  end

  def authorization_headers(mime_symbol, authentication_token)
    accept_header(mime_symbol).merge(
      "Authorization" => "Token token=#{authentication_token}"
    )
  end
end
