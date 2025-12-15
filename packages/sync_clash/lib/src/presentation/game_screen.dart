import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sync_clash/src/game/my_game.dart';
import 'package:sync_clash/sync_clash.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final MyGame _game;
  GameStatus _status = GameStatus.choosing;

  final String playerId = 'player_0';

  PlayerAction _selectedAction = PlayerAction.none;

  int _playerLife = 3;
  // Vector2 _playerPosition = Vector2(4, 4);
  // Vector2? _targetPosition;

  bool get canValidate => _status == GameStatus.choosing
  // && _selectedAction != PlayerAction.none
  ;

  @override
  void initState() {
    super.initState();
    _game = MyGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildGameView(),
            const SizedBox(height: 16),
            _buildLifeWidget(),
            const SizedBox(height: 24),
            _buildActionPad(),
            const SizedBox(height: 16),
            _buildValidateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameView() {
    return Center(
      child: SizedBox(
        height: 54 * 9,
        width: 54 * 9,
        child: GameWidget(game: _game),
      ),
    );
  }

  Widget _buildLifeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Icon(
          index < _playerLife ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildActionPad() {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _actionButton(
            icon: Icons.arrow_forward,
            label: 'Move',
            color: Colors.green,
            action: PlayerAction.move,
            alignment: Alignment.centerRight,
          ),
          _actionButton(
            icon: Icons.flash_on,
            label: 'Atk',
            color: Colors.red,
            action: PlayerAction.melee,
            alignment: Alignment.centerLeft,
          ),
          _actionButton(
            icon: Icons.bolt,
            label: 'Shoot',
            color: Colors.orange,
            action: PlayerAction.shoot,
            alignment: Alignment.topCenter,
          ),
          _actionButton(
            icon: Icons.shield,
            label: 'Defend',
            color: Colors.blue,
            action: PlayerAction.block,
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required PlayerAction action,
    required Alignment alignment,
  }) {
    final isSelected = _selectedAction == action;

    return Align(
      alignment: alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: label,
            backgroundColor: canValidate
                ? isSelected
                      ? color
                      : color.withOpacity(0.4)
                : Colors.grey.withOpacity(0.4),
            onPressed: () {
              setState(() {
                if (canValidate) {
                  _selectedAction = action;
                  _game.selectAction(playerId, action);
                }
              });
            },
            child: Icon(icon, size: 32),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildValidateButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: canValidate ? Colors.green : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
      onPressed: () => _onValidate(),
      // canValidate ? _onValidate : null,
      child: const Text('Valider', style: TextStyle(fontSize: 18)),
    );
  }

  void _onValidate() {
    _game.validateTurn(playerId);

    setState(() {
      // _status = GameStatus.showing;
      _selectedAction = PlayerAction.none;
    });
  }
}
