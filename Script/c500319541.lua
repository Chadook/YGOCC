--Winged Beast Of Gust Vine
function c500319541.initial_effect(c)
			aux.AddFusionProcCodeFun(c,50031102,aux.FilterBoolFunction(c500319541.ffilter),1,true,false)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500319541,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,500319541)
	e1:SetCondition(c500319541.condition)
	e1:SetTarget(c500319541.target)
	e1:SetOperation(c500319541.operation)
	c:RegisterEffect(e1)
	end
	function c500319541.ffilter(c)
	return  c:GetLevel()<=4 and c:GetCode()~=500319541 and not c:IsCode(500319541)  and c:GetLevel()>0  or c:IsHasEffect(500317451)
end
function c500319541.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION and re:GetHandler():IsSetCard(0x786d)
end
function c500319541.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,30459350) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
	function c500319541.mrfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x786d) or c:IsAttribute(ATTRIBUTE_WIND)
end
function c500319541.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(p,c500319541.mrfilter,p,LOCATION_HAND,0,1,1,nil)
	local tg=g:GetFirst()
	if tg then
		if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==0 then
			Duel.ConfirmCards(1-p,tg)
			Duel.ShuffleHand(p)
		end
	else
    Duel.Remove(Duel.GetFieldGroup(p,LOCATION_HAND),POS_FACEUP,REASON_EFFECT)
	end
end