# Flutter Test;

플루터 테스트 예제를 위해서 만든 프로젝트입니다.;

## Getting Started;
Flutter 테스트는 크게 유닛테스트(unit test), 위젯테스트(widget test), 통합테스트(integration test) 나뉘어져 있습니다.;
현재 테스트 예제에서는 유닛테스트와 위젯 테스트를 다루고 통합테스트는 다루지 않도록 하겠습니다.;

## 테스트;
테스트는 다른 무엇보다 협업환경에서 더 나은 개발 경험을 제공을 해줍니다. 테스트를 통해서 동료의 코드의 의도를 더욱 명확하게 파악할 수 있습니다.;

그리고 지속적인 테스트를 통해서 다른 곳의 코드를 바꾸었을 때 어떤 곳에서 의도하지 않은 동작을 하는지 알 수 있게 됩니다. 이를 통해서 협업이나 개인이 코드를 생성하는 동안 일으킬 수 있는 인간적 오류를 최소화 하는데 도움을 주며 개발기간 중에 전체적인 시스템을 망가뜨리지 않는데 기여합니다.;

그리고 서비스의 질을 보장하는 역할을 하여서 기업에게 위험부담을 줄여줄 수 있습니다.;

이러한 요소들로 인하여 기업과 개발자들은 테스트를 합니다.;

유닛 테스트가 가장 작은 개념이고 위젯테스트가 그 다음 마지막으로 통합테스트입니다.

#이번에는 상태관리 패키지인 provider를 더한 테스트는 안이루어지고 가장 기본적인 flutter를 이용한 test만을 다룰 것입니다.;

### 유닛테스트(unit test);
가장 작은 단위의 테스트로 `class`와 `함수`단위에서의 테스트를 다룹니다. 테스트를 다룰 때는 성공할 경우만이 아닌 실패할 경우 어떤 실패를 할 것인지 또한 예측을 해야만 완전히 테스트를 끝냈다고 말할 수 있습니다.;

### 위젯테스트(widget test);
유닛테스트는 `class`와 `함수` 등을 테스트하는 것 이었다면 위젯테스트는 UI 상에서 보여지는 위젯을 테스트하는 역할을 합니다. 위젯테스트는 현재 위젯트리 안에서 어떤 위젯들이 형성되어 있는지를 통해서 위젯테스트를 진행합니다.


### 플루터 참고자료;
- [Lab: Write your first Flutter app;](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples;](https://flutter.dev/docs/cookbook)
### 플루터 테스트 참고 자료
- [Flutter Test Cookbook;](https://flutter.dev/docs/cookbook/testing/unit/introduction)
- [Mockito Document;](https://pub.dev/documentation/mockito/latest/)
