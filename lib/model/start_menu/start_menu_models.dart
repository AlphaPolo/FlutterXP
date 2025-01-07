class StartMenuModel {
  final String label;
  final String? subLabel;
  final String iconAsset;

  const StartMenuModel({
    required this.label,
    required this.iconAsset,
    this.subLabel,
  });
}

const List<StartMenuModel> startMenuModels = [
  StartMenuModel(label: 'Internet', subLabel: 'Internet Explorer', iconAsset: 'assets/images/icon_internet_32.png'),
  StartMenuModel(label: 'E-mail', subLabel: 'Outlook Express', iconAsset: 'assets/images/icon_email_32.png'),
  StartMenuModel(label: 'Minesweeper', iconAsset: 'assets/images/minesweeper/icon_mine_32.png'),
  StartMenuModel(label: 'Notepad', iconAsset: 'assets/images/icon_notepad_32.png'),
  StartMenuModel(label: 'Paint', iconAsset: 'assets/images/icon_paint_32.png'),
  StartMenuModel(label: 'Windows Media Player', iconAsset: 'assets/images/icon_media_player_32.png'),
  StartMenuModel(label: 'Windows Messenger', iconAsset: 'assets/images/icon_msn_32.png'),
];

const List<StartMenuModel> rightSideMenuModels = [
  StartMenuModel(label: 'My Documents', iconAsset: 'assets/images/icon_my_documents_32.png'),
  StartMenuModel(label: 'My Recent Documents', iconAsset: 'assets/images/icon_my_recent_documents_32.png'),
  StartMenuModel(label: 'My Pictures', iconAsset: 'assets/images/icon_my_pictures_32.png'),
  StartMenuModel(label: 'My Music', iconAsset: 'assets/images/icon_my_music_32.png'),
  StartMenuModel(label: 'My Computer', iconAsset: 'assets/images/icon_computer_32.png'),
  StartMenuModel(label: 'Control Panel', iconAsset: 'assets/images/icon_control_panel_32.png'),
  StartMenuModel(label: 'Set Program Access and Defaults', iconAsset: 'assets/images/icon_program_asset_32.png'),
  StartMenuModel(label: 'Connect to', iconAsset: 'assets/images/icon_connect_to_32.png'),
  StartMenuModel(label: 'Printers and Faxes', iconAsset: 'assets/images/icon_print_and_fax_32.png'),
  StartMenuModel(label: 'Help and Support', iconAsset: 'assets/images/icon_support_32.png'),
  StartMenuModel(label: 'Search', iconAsset: 'assets/images/icon_search_32.png'),
  StartMenuModel(label: 'Run...', iconAsset: 'assets/images/icon_run_32.png'),
];