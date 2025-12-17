import 'package:flame/game.dart' hide Game;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messages/messages.dart';
import 'package:sync_clash/src/game/data/game_providers.dart';
import 'package:sync_clash/src/game/my_game.dart';
import 'package:sync_clash/sync_clash.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({required this.syncedId, super.key});

  final SyncedRoomId syncedId;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final MyGame _game;

  final String playerId = 'player_0';

  PlayerAction _selectedAction = PlayerAction.none;

  int _playerLife = 3;
  // Vector2 _playerPosition = Vector2(4, 4);
  // Vector2? _targetPosition;

  bool canValidate = true;
  // && _selectedAction != PlayerAction.none
  // bool get canValidate => _game.status == GameStatus.choosing;

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
        child: Consumer(
          builder: (context, ref, child) {
            final syncedData = ref.watch(gameStreamProvider(widget.syncedId));

            return syncedData.when(
              data: (synced) {
                if (synced.started == false) {
                  ref
                      .read(messageRepositoryProvider)
                      .newStatus(widget.syncedId, GameStatus.starting);
                  // ref
                  //     .read(messageRepositoryProvider)
                  //     .sendThis<Game>(widget.syncedId, Game());
                  ref.read(messageRepositoryProvider).startMe(widget.syncedId);
                }

                if (synced.status == GameStatus.choosing && !canValidate) {
                  canValidate = true;
                }

                return Column(
                  children: [
                    _buildGameView(),
                    const SizedBox(height: 16),
                    _buildLifeWidget(),
                    const SizedBox(height: 24),
                    _buildActionPad(),
                    const SizedBox(height: 16),
                    _buildValidateButton(),
                  ],
                );
              },
              error: (error, stackTrace) {
                debugPrint(stackTrace.toString());
                return Center(child: Text(error.toString()));
              },
              loading: () => const Center(child: CircularProgressIndicator()),
            );
          },
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
            backgroundColor: isSelected ? color : color.withOpacity(0.4),
            onPressed: () {
              setState(() {
                if (canValidate) {
                  _selectedAction = action;
                  _game.selectAction(playerId, action);
                }
              });
            },
            child: Icon(icon, size: 32, color: Colors.white),
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
      child: const Text(
        'Valider',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  void _onValidate() {
    _game.validateTurn(playerId);

    setState(() {
      canValidate = !canValidate;
      _selectedAction = PlayerAction.none;
    });
  }
}
