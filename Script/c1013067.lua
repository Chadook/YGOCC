--Ghost Soldier #1
function c1013067.initial_effect(c)
	--Negate Attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1013067,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,1013067)
	e1:SetCost(c1013067.atkcost)
	e1:SetCondition(c1013067.atkcon)
	e1:SetOperation(c1013067.atkop)
	c:RegisterEffect(e1)
	--Increase Level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1013067,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1013067)
	e2:SetOperation(c1013067.tgop)
	c:RegisterEffect(e2)
end
function c1013067.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	local lv=e:GetHandler():GetLevel()
	e:SetLabel(lv)
end
function c1013067.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c1013067.spfilter(c,e,tp,lv)
	return c~=e:GetHandler() and c:IsType(TYPE_MONSTER) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1013067.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsAbleToHand() then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		local lv=e:GetLabel()
		if not Duel.IsExistingMatchingCard(c1013067.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,lv) then return end
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1013067.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,lv)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c1013067.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(1)
		c:RegisterEffect(e1)
	end
end