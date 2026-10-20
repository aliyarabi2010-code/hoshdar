class CommandCode {
  final String code;
  final bool isActivate;

  CommandCode({required this.code, required this.isActivate});

  Map<String, dynamic> toJson() => {
        'code': code,
        'isActivate': isActivate,
      };

  factory CommandCode.fromJson(Map<String, dynamic> json) => CommandCode(
        code: json['code'],
        isActivate: json['isActivate'],
      );
}
