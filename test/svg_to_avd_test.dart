import 'package:svg_to_avd/errors/invalid_svg_string_exception.dart';
import 'package:svg_to_avd/svg_to_avd.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('svgToAvd', () {
    test(
      'parses the svg into a avd string',
      () {
        const input = '''
        <svg width="26" height="24" viewBox="0 0 26 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <g 
            transform="rotate(-10) translate(-3 7.23) scale(1 0.5)" 
            stroke="#909943"
            >
            <path 
              id="nice" 
              d="M24.255 8.04L17.406 7.04L14.346 0.833999C13.796 -0.272001 12.208 -0.286001 11.655 0.833999L8.59401 7.041L1.74501 8.039C0.517007 8.217 0.0250076 9.731 0.915008 10.6L5.87001 15.428L4.69801 22.248C4.48801 23.481 5.78601 24.404 6.87301 23.828L13 20.607L19.127 23.827C20.214 24.398 21.513 23.48 21.302 22.247L20.13 15.427L25.084 10.598C25.975 9.731 25.483 8.218 24.254 8.039L24.255 8.04Z" 
              fill="#FFBD18"
              />
            <line x1="0" y1="20" x2="100" y2="20" />
          </g>
        </svg>
      ''';

        final result = svgToAvd(input);

        expect(
          result,
          XmlDocument.parse(
            '''
            <vector xmlns:android="http://schemas.android.com/apk/res/android"
                android:width="26dp"
                android:height="24dp"
                android:viewportWidth="26.0"
                android:viewportHeight="24.0">

                <group
                        android:rotation="-10"
                        android:translateX="-3"
                        android:translateY="7.23"
                        android:scaleY="0.5">
                    <path
                        android:fillColor="#FFBD18"
                        android:strokeWidth="1"
                        android:strokeColor="#909943"
                        android:pathData="M24.255 8.04L17.406 7.04L14.346 0.833999C13.796 -0.272001 12.208 -0.286001 11.655 0.833999L8.59401 7.041L1.74501 8.039C0.517007 8.217 0.0250076 9.731 0.915008 10.6L5.87001 15.428L4.69801 22.248C4.48801 23.481 5.78601 24.404 6.87301 23.828L13 20.607L19.127 23.827C20.214 24.398 21.513 23.48 21.302 22.247L20.13 15.427L25.084 10.598C25.975 9.731 25.483 8.218 24.254 8.039L24.255 8.04Z" 
                        />
                    <path 
                        android:fillColor="#000000"
                        android:strokeWidth="1"
                        android:strokeColor="#909943"
                        android:pathData="M 0.0 20.0 L 100.0 20.0"
                        />
                </group>
            </vector>
          ''',
          ).toXmlString(pretty: true),
        );
      },
    );

    test('throws a XmlParserException when input is not valid svg or xml', () {
      void shouldThrow() => svgToAvd('svg error');

      expect(shouldThrow, throwsA(isA<XmlParserException>()));
    });

    test('throws an InvalidSvgStringException error when input is not a svg',
        () {
      void shouldThrow() => svgToAvd('<nice></nice>');

      expect(shouldThrow, throwsA(isA<InvalidSvgStringException>()));
    });
  });
}
