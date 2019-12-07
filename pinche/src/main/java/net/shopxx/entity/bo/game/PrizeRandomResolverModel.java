package net.shopxx.entity.bo.game;

import java.util.Arrays;
import java.util.List;

/**
 * 奖品随机数视图解析对象
 */
public class PrizeRandomResolverModel {
    private List<Integer> oneGrade = Arrays.asList(new Integer[]{99999});
    private List<Integer> twoGrade = Arrays.asList(new Integer[]{88888,66666});
    private List<Integer> threeGrade = Arrays.asList(new Integer[]{33333,22222,11111,44444,55555,77777});

    private int firstNum;
    private int twoNum;

    public int getFirstNum() {
        return firstNum;
    }

    public int getTwoNum() {
        return twoNum;
    }


    /**
     * 通过随机数获取对应的奖励的级别
     * 0 是无奖励
     * @return
     */
    public int resolverRandom(int random){
        if(oneGrade.contains(random)){
            return 1;
        }
        if(twoGrade.contains(random)){
            return 2;
        }
        if(threeGrade.contains(random)){
            return 3;
        }
        String  randomStr=String.valueOf(random);
        this.firstNum = Integer.valueOf(randomStr.substring(randomStr.length()-1,randomStr.length()));
        this.twoNum = Integer.valueOf(randomStr.substring(randomStr.length()-2,randomStr.length()-1));
        if(firstNum==6){
            if(twoNum==6){
                return 4;
            }
            if(twoNum ==0 || twoNum==5){
                return 5;
            }
                return 6;

        }else{
            return 0;
        }
    }


}
