class Regexps {
    public static let ipAddress = #"^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)(\.(?!$)|$)){4}$"#
    public static let domain =  #"^(([a-z0-9|-]+\.)*[a-z0-9|-]+\.[a-z]+)$"#
    public static let path = #"^\/\b([A-Za-z0-9_\-~/]*)[^\/|\.|\:]$"#
}
