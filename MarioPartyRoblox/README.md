# Mario Party для Roblox — стартовый каркас

Минимальный проект раундовой игры с мини-играми: лобби, отсчёт, выбор случайной
мини-игры, очки за места, победитель в конце. Сейчас есть одна мини-игра —
«Исчезающий пол».

## Структура архива

```
ServerScriptService/
  GameManager.server.lua            -> Script (главный игровой цикл)
  Minigames/
    DisappearingFloor.lua           -> ModuleScript (мини-игра)
StarterGui/
  ScreenGui/
    StatusClient.client.lua         -> LocalScript (показ статуса)
```

Файлы нужно перенести в Roblox Studio вручную: создаёшь объект нужного типа,
открываешь его и вставляешь код из файла.

## Установка в Roblox Studio

1. Создай **Baseplate** (или любой place). Оставь обычный `SpawnLocation` — это лобби.
2. В `ReplicatedStorage` добавь **RemoteEvent** и назови его точно `StatusUpdate`.
3. В `ServerScriptService` добавь **Script** с именем `GameManager`
   и вставь код из `GameManager.server.lua`.
4. В `ServerScriptService` добавь **Folder** с именем `Minigames`,
   внутри создай **ModuleScript** `DisappearingFloor` и вставь код из `DisappearingFloor.lua`.
5. В `StarterGui` добавь **ScreenGui**, внутри него **TextLabel** с именем `StatusLabel`
   (растяни сверху экрана, увеличь размер шрифта, включи `TextScaled` при желании).
6. Внутри того же ScreenGui добавь **LocalScript** и вставь код из `StatusClient.client.lua`.

## Как проверить

Вкладка **Test** -> выбери **Local Server** с 2 игроками (минимум задаётся
`MIN_PLAYERS`) -> **Start**. Должен пойти отсчёт, затем раунд с исчезающими плитками.

## Настройки (вверху GameManager)

| Переменная    | Что делает                                  |
|---------------|---------------------------------------------|
| `MIN_PLAYERS` | минимум игроков для старта                  |
| `LOBBY_TIME`  | секунд ожидания перед началом игры          |
| `ROUNDS`      | сколько раундов в одной игре                |
| `POINTS`      | очки за места: 1-е, 2-е, 3-е, 4-е           |

## Как добавить новую мини-игру

1. Создай новый ModuleScript в папке `Minigames`.
2. Задай поля `Name` (название, показывается игрокам) и функцию `Run(participants)`.
3. `Run` принимает список игроков и должен вернуть список игроков
   **от победителя к проигравшему**.
4. В конце `Run` удали всё, что создал (карту, объекты).

`GameManager` сам подхватит новый модуль, менять его не нужно.

Шаблон:

```lua
local module = {}
module.Name = "Название игры"

function module.Run(participants)
	-- создать арену, телепортировать игроков, провести игру
	local results = {}
	-- ... заполнить results от 1-го места к последнему
	return results
end

return module
```

## Идеи для развития

- Таблица очков на экране (Leaderboard / отдельный GUI).
- Мини-игры: собери монеты, гонка до финиша, уклонение от шаров, король горы.
- Голосование за мини-игру, звуки и эффекты, экран результатов раунда.
- Сохранение статистики и монет через DataStore.
- Проверка на телефоне: интерфейс и управление.

## Если что-то не работает

Открой окно **Output** (View -> Output) и посмотри текст ошибки.
Частые причины: неверное имя `StatusUpdate`, `Minigames` или `StatusLabel`,
либо скрипт вставлен не того типа (Script / ModuleScript / LocalScript).
